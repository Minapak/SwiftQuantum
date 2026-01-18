#!/usr/bin/env python3
"""
IBM Quantum API Integration Test for SwiftQuantum iOS App
Tests the complete flow: IAM Token → Service CRN → Backends → Job Submission → Results
"""

import requests
import json
import time
import math
from datetime import datetime

# Configuration
API_KEY = os.environ.get("IBM_QUANTUM_API_KEY", "YOUR_IBM_QUANTUM_API_KEY")
IAM_TOKEN_URL = "https://iam.cloud.ibm.com/identity/token"
QUANTUM_API_URL = "https://quantum.cloud.ibm.com/api/v1"
RESOURCE_CONTROLLER_URL = "https://resource-controller.cloud.ibm.com/v2/resource_instances"

# Store results for documentation
test_results = {
    "steps": [],
    "errors": [],
    "success": False
}

def log_step(step_num, title, status, details=None, error=None):
    """Log a test step for documentation"""
    result = {
        "step": step_num,
        "title": title,
        "status": status,
        "timestamp": datetime.now().isoformat(),
        "details": details
    }
    if error:
        result["error"] = error
        test_results["errors"].append({"step": step_num, "error": error})
    test_results["steps"].append(result)

    status_icon = "✅" if status == "success" else "❌" if status == "error" else "⏳"
    print(f"\n{'='*60}")
    print(f"{status_icon} Step {step_num}: {title}")
    print(f"{'='*60}")
    if details:
        print(json.dumps(details, indent=2, ensure_ascii=False) if isinstance(details, dict) else details)
    if error:
        print(f"❌ Error: {error}")

def step1_get_iam_token():
    """Step 1: Acquire IAM Token from API Key"""
    log_step(1, "IAM Token 획득", "in_progress")

    try:
        response = requests.post(
            IAM_TOKEN_URL,
            headers={"Content-Type": "application/x-www-form-urlencoded"},
            data=f"grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey={API_KEY}",
            timeout=30
        )

        if response.status_code == 200:
            data = response.json()
            token = data.get("access_token")
            expires_in = data.get("expires_in", 3600)

            log_step(1, "IAM Token 획득", "success", {
                "status_code": response.status_code,
                "token_type": data.get("token_type"),
                "expires_in": f"{expires_in}초 ({expires_in//60}분)",
                "token_preview": f"{token[:50]}...{token[-20:]}" if token else None
            })
            return token
        else:
            log_step(1, "IAM Token 획득", "error",
                    {"status_code": response.status_code},
                    response.text)
            return None

    except Exception as e:
        log_step(1, "IAM Token 획득", "error", error=str(e))
        return None

def step2_get_service_crn(bearer_token):
    """Step 2: Get Qiskit Runtime Service CRN"""
    log_step(2, "Service CRN 조회", "in_progress")

    try:
        # resource_id for Qiskit Runtime
        qiskit_runtime_resource_id = "b6049020-80f4-11eb-a0f7-e35ec9b4054f"

        response = requests.get(
            f"{RESOURCE_CONTROLLER_URL}?resource_id={qiskit_runtime_resource_id}",
            headers={"Authorization": f"Bearer {bearer_token}"},
            timeout=30
        )

        if response.status_code == 200:
            data = response.json()
            resources = data.get("resources", [])

            if resources:
                instance = resources[0]
                crn = instance.get("crn")
                name = instance.get("name")
                region = instance.get("region_id")
                state = instance.get("state")

                log_step(2, "Service CRN 조회", "success", {
                    "instance_name": name,
                    "region": region,
                    "state": state,
                    "crn": crn,
                    "total_instances": len(resources)
                })
                return crn
            else:
                log_step(2, "Service CRN 조회", "error",
                        error="No Qiskit Runtime instances found. Please create one at quantum.ibm.com")
                return None
        else:
            log_step(2, "Service CRN 조회", "error",
                    {"status_code": response.status_code},
                    response.text)
            return None

    except Exception as e:
        log_step(2, "Service CRN 조회", "error", error=str(e))
        return None

def step3_get_backends(bearer_token, service_crn):
    """Step 3: List available QPU backends"""
    log_step(3, "QPU 백엔드 목록 조회", "in_progress")

    try:
        headers = {
            "Authorization": f"Bearer {bearer_token}",
            "Service-CRN": service_crn,
            "IBM-API-Version": "2025-05-01"
        }

        response = requests.get(
            f"{QUANTUM_API_URL}/backends",
            headers=headers,
            timeout=30
        )

        if response.status_code == 200:
            backends = response.json()

            # Filter and format backend info
            backend_list = []
            for backend in backends.get("devices", backends) if isinstance(backends, dict) else backends:
                if isinstance(backend, dict):
                    name = backend.get("name", backend.get("backend_name", "unknown"))
                    n_qubits = backend.get("n_qubits", backend.get("num_qubits", "N/A"))
                    status = backend.get("status", backend.get("backend_status", {}))
                    operational = status.get("operational", True) if isinstance(status, dict) else True
                    pending_jobs = status.get("pending_jobs", 0) if isinstance(status, dict) else 0
                    processor_type = backend.get("processor_type", {})

                    backend_list.append({
                        "name": name,
                        "qubits": n_qubits,
                        "operational": operational,
                        "pending_jobs": pending_jobs,
                        "processor": processor_type.get("family", "Unknown") if isinstance(processor_type, dict) else "Unknown"
                    })

            log_step(3, "QPU 백엔드 목록 조회", "success", {
                "total_backends": len(backend_list),
                "backends": backend_list[:10]  # Show first 10
            })
            return backends, backend_list
        else:
            log_step(3, "QPU 백엔드 목록 조회", "error",
                    {"status_code": response.status_code},
                    response.text)
            return None, None

    except Exception as e:
        log_step(3, "QPU 백엔드 목록 조회", "error", error=str(e))
        return None, None

def get_transpiled_bell_state_qasm(n_qubits=156):
    """
    Generate transpiled Bell State QASM for Heron processor
    Native gates: cz, id, rx, rz, rzz, sx, x

    H gate decomposition: Rz(π/2) → SX → Rz(π/2)
    CX decomposition: H(target) → CZ → H(target)
    """
    pi_2 = math.pi / 2

    qasm = f'''OPENQASM 3.0;
include "stdgates.inc";
qubit[{n_qubits}] q;
bit[2] c;

// H gate on q[0]: Rz(π/2) → SX → Rz(π/2)
rz({pi_2}) q[0];
sx q[0];
rz({pi_2}) q[0];

// CX(q[0], q[1]) = H(q[1]) → CZ(q[0], q[1]) → H(q[1])
// First H on q[1]
rz({pi_2}) q[1];
sx q[1];
rz({pi_2}) q[1];

// CZ gate (native)
cz q[0], q[1];

// Second H on q[1]
rz({pi_2}) q[1];
sx q[1];
rz({pi_2}) q[1];

// Measure
c[0] = measure q[0];
c[1] = measure q[1];
'''
    return qasm

def step4_submit_job(bearer_token, service_crn, backend_name="ibm_fez"):
    """Step 4: Submit Bell State circuit to QPU"""
    log_step(4, f"Bell State Job 제출 ({backend_name})", "in_progress")

    try:
        headers = {
            "Authorization": f"Bearer {bearer_token}",
            "Service-CRN": service_crn,
            "IBM-API-Version": "2025-05-01",
            "Content-Type": "application/json"
        }

        # Get transpiled QASM
        transpiled_qasm = get_transpiled_bell_state_qasm(156)

        # Prepare job data with Primitives V2
        job_data = {
            "program_id": "sampler",
            "backend": backend_name,
            "params": {
                "version": 2,
                "pubs": [[transpiled_qasm]],
                "options": {
                    "default_shots": 1024
                }
            }
        }

        print(f"\n📤 Submitting to {backend_name}...")
        print(f"Circuit (transpiled):\n{transpiled_qasm[:500]}...")

        response = requests.post(
            f"{QUANTUM_API_URL}/jobs",
            headers=headers,
            json=job_data,
            timeout=60
        )

        if response.status_code in [200, 201]:
            job_info = response.json()
            job_id = job_info.get("id")

            log_step(4, f"Bell State Job 제출 ({backend_name})", "success", {
                "job_id": job_id,
                "status": job_info.get("status"),
                "backend": job_info.get("backend"),
                "created": job_info.get("created")
            })
            return job_id, job_info
        else:
            error_data = response.json() if response.text else {}
            error_code = error_data.get("code", response.status_code)
            error_message = error_data.get("message", response.text)

            log_step(4, f"Bell State Job 제출 ({backend_name})", "error", {
                "status_code": response.status_code,
                "error_code": error_code,
                "error_message": error_message
            }, f"Code {error_code}: {error_message}")
            return None, error_data

    except Exception as e:
        log_step(4, f"Bell State Job 제출 ({backend_name})", "error", error=str(e))
        return None, None

def step5_poll_job_status(bearer_token, service_crn, job_id, max_wait=300):
    """Step 5: Poll job status until completion"""
    log_step(5, f"Job 상태 폴링 ({job_id})", "in_progress")

    try:
        headers = {
            "Authorization": f"Bearer {bearer_token}",
            "Service-CRN": service_crn,
            "IBM-API-Version": "2025-05-01"
        }

        start_time = time.time()
        poll_count = 0

        while (time.time() - start_time) < max_wait:
            poll_count += 1
            response = requests.get(
                f"{QUANTUM_API_URL}/jobs/{job_id}",
                headers=headers,
                timeout=30
            )

            if response.status_code == 200:
                job_info = response.json()
                status = job_info.get("status", "").upper()

                print(f"  ⏳ Poll #{poll_count}: Status = {status}")

                if status == "COMPLETED":
                    elapsed = time.time() - start_time
                    log_step(5, f"Job 상태 폴링 ({job_id})", "success", {
                        "final_status": status,
                        "elapsed_time": f"{elapsed:.1f}초",
                        "poll_count": poll_count
                    })
                    return job_info

                elif status in ["FAILED", "CANCELLED"]:
                    log_step(5, f"Job 상태 폴링 ({job_id})", "error", {
                        "final_status": status,
                        "error_message": job_info.get("error_message", "Unknown error")
                    }, f"Job {status}")
                    return job_info

                # Wait before next poll
                time.sleep(5)
            else:
                print(f"  ⚠️ Poll error: {response.status_code}")
                time.sleep(5)

        log_step(5, f"Job 상태 폴링 ({job_id})", "error",
                error=f"Timeout after {max_wait}초")
        return None

    except Exception as e:
        log_step(5, f"Job 상태 폴링 ({job_id})", "error", error=str(e))
        return None

def step6_get_results(bearer_token, service_crn, job_id):
    """Step 6: Retrieve job results"""
    log_step(6, f"결과 조회 ({job_id})", "in_progress")

    try:
        headers = {
            "Authorization": f"Bearer {bearer_token}",
            "Service-CRN": service_crn,
            "IBM-API-Version": "2025-05-01"
        }

        response = requests.get(
            f"{QUANTUM_API_URL}/jobs/{job_id}/results",
            headers=headers,
            timeout=30
        )

        if response.status_code == 200:
            results = response.json()

            # Parse measurement results
            measurement_data = analyze_bell_state_results(results)

            log_step(6, f"결과 조회 ({job_id})", "success", measurement_data)
            return results, measurement_data
        else:
            log_step(6, f"결과 조회 ({job_id})", "error",
                    {"status_code": response.status_code},
                    response.text)
            return None, None

    except Exception as e:
        log_step(6, f"결과 조회 ({job_id})", "error", error=str(e))
        return None, None

def analyze_bell_state_results(results):
    """Analyze Bell State measurement results"""
    try:
        # Extract counts from results structure
        # Structure varies, try common patterns
        counts = {}

        if isinstance(results, dict):
            if "results" in results:
                res_data = results["results"]
                if isinstance(res_data, list) and len(res_data) > 0:
                    pub_result = res_data[0]
                    if "data" in pub_result:
                        counts = pub_result["data"].get("c", pub_result["data"])
                    elif "counts" in pub_result:
                        counts = pub_result["counts"]
            elif "counts" in results:
                counts = results["counts"]

        if not counts:
            counts = results  # Fallback

        # Calculate statistics
        total = sum(counts.values()) if isinstance(counts, dict) else 0

        if total > 0:
            # Bell state analysis
            correlated = counts.get("00", 0) + counts.get("11", 0) + \
                        counts.get("0x0", 0) + counts.get("0x3", 0)  # Handle hex format
            uncorrelated = total - correlated
            fidelity = (correlated / total) * 100 if total > 0 else 0

            analysis = {
                "total_shots": total,
                "counts": dict(list(counts.items())[:10]),  # First 10
                "correlated_count": correlated,
                "uncorrelated_count": uncorrelated,
                "fidelity": f"{fidelity:.1f}%"
            }
        else:
            analysis = {
                "raw_results": str(results)[:500]
            }

        return analysis

    except Exception as e:
        return {"parse_error": str(e), "raw": str(results)[:500]}

def main():
    """Run complete IBM Quantum integration test"""
    print("\n" + "="*70)
    print("🔬 SwiftQuantum iOS App - IBM Quantum 연동 테스트")
    print("="*70)
    print(f"시작 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("="*70)

    # Step 1: Get IAM Token
    bearer_token = step1_get_iam_token()
    if not bearer_token:
        print("\n❌ IAM Token 획득 실패. 테스트 중단.")
        return test_results

    # Step 2: Get Service CRN
    service_crn = step2_get_service_crn(bearer_token)
    if not service_crn:
        print("\n❌ Service CRN 조회 실패. 테스트 중단.")
        return test_results

    # Step 3: Get Backends
    backends_raw, backends_list = step3_get_backends(bearer_token, service_crn)
    if not backends_list:
        print("\n❌ 백엔드 목록 조회 실패. 테스트 중단.")
        return test_results

    # Find best backend (prefer ibm_fez or lowest queue)
    target_backend = "ibm_fez"  # Default
    for backend in backends_list:
        if backend.get("name") == "ibm_fez" and backend.get("operational"):
            target_backend = "ibm_fez"
            break
        elif backend.get("operational") and backend.get("pending_jobs", 999) < 100:
            target_backend = backend.get("name")

    print(f"\n🎯 선택된 백엔드: {target_backend}")

    # Step 4: Submit Job
    job_id, job_info = step4_submit_job(bearer_token, service_crn, target_backend)
    if not job_id:
        print("\n❌ Job 제출 실패. 테스트 중단.")
        return test_results

    # Step 5: Poll Status
    final_status = step5_poll_job_status(bearer_token, service_crn, job_id)
    if not final_status or final_status.get("status", "").upper() != "COMPLETED":
        print("\n❌ Job 완료되지 않음. 테스트 중단.")
        return test_results

    # Step 6: Get Results
    results, analysis = step6_get_results(bearer_token, service_crn, job_id)

    # Final Summary
    print("\n" + "="*70)
    print("📊 테스트 완료 요약")
    print("="*70)

    test_results["success"] = True
    test_results["summary"] = {
        "job_id": job_id,
        "backend": target_backend,
        "analysis": analysis
    }

    print(json.dumps(test_results["summary"], indent=2, ensure_ascii=False))

    return test_results

if __name__ == "__main__":
    results = main()

    # Save results to file
    with open("/Users/eunmin/Desktop/WORK/SwiftQuantum/Scripts/test_results.json", "w") as f:
        json.dump(results, f, indent=2, ensure_ascii=False, default=str)

    print(f"\n📁 결과 저장됨: Scripts/test_results.json")
