# SwiftQuantum iOS App - Complete Feature Documentation

**Version**: 2.2.4
**Platform**: iOS 18+ / macOS 15+
**Languages**: English, Korean, Japanese, Chinese (Simplified), German

---

## Overview

SwiftQuantum is a premium quantum computing platform for iOS that combines local simulation, real IBM Quantum hardware connectivity, and educational content. The app uses a 4-Hub navigation system based on Apple Human Interface Guidelines.

### Navigation Structure

| Hub | Tab Name | Icon | Description |
|-----|----------|------|-------------|
| 1 | Lab | `atom` | Quantum state control and measurement |
| 2 | Circuits | `square.grid.3x3` | Pre-built circuit templates and builder |
| 3 | Factory | `cpu.fill` | QuantumBridge QPU connection |
| 4 | More | `ellipsis` | Academy, Industry, Profile, Settings |

---

## Tab 1: Lab Hub

The Lab Hub is the core quantum experimentation interface, combining Controls, Measurement, and Information panels.

### 1.1 Control Panel

**Purpose**: Manipulate quantum states through probability and phase controls.

| Feature | Description | Interaction |
|---------|-------------|-------------|
| Probability Slider | Adjusts |0⟩ and |1⟩ probability amplitudes | Drag slider 0-100% |
| Phase Slider | Controls relative phase between states | Drag slider 0-2π |
| Bloch Sphere | 3D visualization of qubit state | Rotate, zoom gestures |
| State Vector Display | Shows α|0⟩ + β|1⟩ notation | Read-only |

**Quantum Gates Available**:

| Gate | Symbol | Matrix | Effect |
|------|--------|--------|--------|
| Hadamard | H | 1/√2 [[1,1],[1,-1]] | Creates superposition |
| Pauli-X | X | [[0,1],[1,0]] | Bit flip (NOT) |
| Pauli-Y | Y | [[0,-i],[i,0]] | Bit + phase flip |
| Pauli-Z | Z | [[1,0],[0,-1]] | Phase flip |
| S Gate | S | [[1,0],[0,i]] | π/2 phase |
| T Gate | T | [[1,0],[0,e^(iπ/4)]] | π/8 phase |

### 1.2 Measurement Panel

**Purpose**: Perform quantum measurements and view statistical results.

| Feature | Description | Output |
|---------|-------------|--------|
| Single Shot | Collapse state to |0⟩ or |1⟩ | Single result |
| Multi-Shot | Run multiple measurements | Histogram |
| Shot Count | Configure 10-10000 shots | Slider |
| Result History | View past measurements | Scrollable list |

**Measurement Statistics**:
- Probability distribution chart
- Mean and standard deviation
- Fidelity with target state

### 1.3 Information Panel

**Purpose**: Educational content about the current quantum state.

| Section | Content |
|---------|---------|
| State Description | Plain-language explanation of current state |
| Mathematical Notation | Dirac notation, density matrix |
| Bloch Coordinates | θ, φ angles on Bloch sphere |
| Historical Context | Related quantum physics concepts |

---

## Tab 2: Circuits Hub (Presets)

The Circuits Hub provides pre-built quantum circuit templates and a circuit builder.

### 2.1 Quick Start Section

**Purpose**: One-tap access to common quantum circuits.

| Circuit | Qubits | Description |
|---------|--------|-------------|
| Bell State | 2 | Creates maximally entangled pair |
| GHZ State | 3 | Three-qubit entanglement |
| Superposition | 1 | Single qubit in |+⟩ state |
| Bit Flip | 1 | X gate demonstration |

### 2.2 Featured Circuits

**Purpose**: Showcase advanced quantum algorithms.

| Category | Circuits |
|----------|----------|
| **Fundamentals** | Superposition, Phase Kickback, Interference |
| **Entanglement** | Bell States, GHZ, W State, CHSH |
| **Algorithms** | Deutsch-Jozsa, Bernstein-Vazirani, Simon |
| **Advanced** | Grover Search, QFT, VQE, QAOA |

### 2.3 Circuit Templates

**Full Template Library**:

| Template | Qubits | Gates | Difficulty | Premium |
|----------|--------|-------|------------|---------|
| Basic Superposition | 1 | 1 | Beginner | Free |
| Bell State | 2 | 2 | Beginner | Free |
| GHZ State | 3 | 3 | Beginner | Free |
| Phase Estimation | 4 | 12 | Intermediate | Pro |
| Grover's Algorithm | 3 | 15 | Intermediate | Pro |
| Quantum Fourier Transform | 4 | 20 | Advanced | Premium |
| Shor's Algorithm (Demo) | 5 | 50+ | Advanced | Premium |

### 2.4 Circuit Detail View

When a circuit is selected:

| Section | Content |
|---------|---------|
| **About** | Description, use cases, complexity |
| **Gates** | Visual circuit diagram with gate labels |
| **Run** | Execute circuit with configurable shots |
| **Results** | Measurement histogram and probabilities |
| **Export** | QASM code export option |

### 2.5 Premium Features (Circuits)

| Feature | Free | Pro | Premium |
|---------|------|-----|---------|
| Basic Templates | ✓ | ✓ | ✓ |
| Advanced Algorithms | - | ✓ | ✓ |
| Custom Circuit Builder | - | ✓ | ✓ |
| Real Hardware Execution | - | ✓ | ✓ |
| Unlimited Daily Runs | - | - | ✓ |

---

## Tab 3: Factory Hub (Bridge)

The Factory Hub connects to real IBM Quantum computers via QuantumBridge.

### 3.1 Connection Status

| Status | Icon | Description |
|--------|------|-------------|
| Connected | Green dot | Active connection to backend |
| Disconnected | Gray dot | No active connection |
| Connecting | Spinner | Establishing connection |
| Error | Red dot | Connection failed |

### 3.2 Backend Selection

**Available Backends**:

| Backend | Qubits | Best For | Queue Time |
|---------|--------|----------|------------|
| **Local Simulator** | 20 | Testing | Instant |
| **IBM Brisbane** | 127 | Production | 5-30 min |
| **IBM Osaka** | 127 | Fast experiments | 2-15 min |
| **IBM Kyoto** | 127 | Research | 10-60 min |

**Backend Detail Sheet**:
- Best use cases
- Advantages (2-3 points)
- Limitations (1-2 points)
- Current queue status

### 3.3 Queue Status Panel

| Metric | Description |
|--------|-------------|
| Pending Jobs | Number of jobs ahead in queue |
| Running Jobs | Currently executing jobs |
| Estimated Wait | Time until your job starts |
| Your Position | Queue position number |

### 3.4 Quick Actions

| Action | Description | Premium |
|--------|-------------|---------|
| **Bell State** | Create 2-qubit entanglement | Pro |
| **GHZ State** | Create 3-qubit entanglement | Pro |
| **Export QASM** | Copy circuit as OpenQASM 3.0 | Free |
| **Continuous Mode** | Auto-repeat every 30 seconds | Premium |

### 3.5 Deploy Section

**Hold-to-Deploy Button**:
- Hold for 2 seconds to deploy circuit
- Visual progress indicator
- Haptic feedback on completion
- Job ID returned on success

### 3.6 Active Jobs Panel

| Column | Description |
|--------|-------------|
| Job ID | Unique identifier (truncated) |
| Status | Queued / Running / Completed / Failed |
| Backend | Target quantum processor |
| Submitted | Timestamp of submission |
| Actions | Cancel (if queued), View Results |

### 3.7 QASM Export Sheet

**Export Options**:
- Copy to clipboard
- Share via system share sheet
- View syntax-highlighted code

**QASM 3.0 Example**:
```qasm
OPENQASM 3.0;
include "stdgates.inc";

qubit[2] q;
bit[2] c;

reset q;
h q[0];
cx q[0], q[1];
c = measure q;
```

### 3.8 Error Correction Panel (Premium)

| Feature | Description |
|---------|-------------|
| Surface Code Visualization | Visual grid of data and ancilla qubits |
| Code Distance | Configurable d=3, d=5, d=7 |
| Logical Error Rate | Calculated based on physical error rate |
| Fidelity Display | Post-correction measurement fidelity |

### 3.9 "Why Use Bridge?" Info Card

Toggleable information card (tap `?` button):
- Real Hardware benefits
- Quantum Advantage explanation
- Authentic Results description

---

## Tab 4: More Hub

The More Hub combines Academy, Industry, Profile, and Settings.

### 4.1 Navigation Cards

| Card | Subtitle | Badge | Destination |
|------|----------|-------|-------------|
| **Academy** | Learn Quantum Computing | N Done / Login | AcademyMarketingView |
| **Industry** | Enterprise Solutions | Premium | IndustryDetailView |
| **Profile** | Your Quantum Journey | Admin / Login | ProfileDetailView |

### 4.2 Academy Marketing View

**Purpose**: Promote QuantumNative companion app.

| Section | Content |
|---------|---------|
| **Hero** | App icon, name, subtitle |
| **Features** | 4 feature rows with icons |
| **Courses** | Horizontal scroll of course cards |
| **Testimonial** | User quote with avatar |
| **CTA** | "Download QuantumNative" button |

**Course Preview Cards**:

| Course | Lessons | Duration | Free |
|--------|---------|----------|------|
| Quantum Basics | 8 | 2h | ✓ |
| Quantum Gates | 12 | 3h | ✓ |
| Entanglement | 10 | 2.5h | - |
| Algorithms | 15 | 4h | - |

### 4.3 Industry Detail View

**Purpose**: Showcase enterprise quantum solutions.

#### Industry Solution Cards

| Industry | Icon | Efficiency Gain | Use Cases |
|----------|------|-----------------|-----------|
| **Finance** | chart.line.uptrend.xyaxis | +52% | Portfolio, Risk, Fraud, HFT |
| **Healthcare** | cross.case.fill | +38% | Drug Discovery, Protein Folding |
| **Logistics** | truck.box.fill | +45% | Route Optimization, Supply Chain |
| **Energy** | bolt.fill | +41% | Grid Optimization, Forecasting |
| **Manufacturing** | gearshape.2.fill | +33% | Quality Control, Maintenance |
| **AI & ML** | brain | +67% | Quantum Neural Networks |

#### ROI Calculator

| Input | Range |
|-------|-------|
| Team Size | 10 - 1000+ |
| Annual IT Budget | $50K - $10M+ |
| Industry Sector | 6 options |

**Output**:
- Estimated Annual Savings
- Payback Period
- Projected Annual Benefit

#### IBM Quantum Ecosystem

**Ecosystem Categories**:

| Category | Projects |
|----------|----------|
| Machine Learning | TorchQuantum, Qiskit ML |
| Chemistry & Physics | Qiskit Nature |
| Optimization | Qiskit Finance, Qiskit Optimization |
| Hardware Providers | IBM Quantum, Azure Quantum, AWS Braket, IonQ |
| Simulation | Qiskit Aer, MQT DDSIM |
| Research | PennyLane, Cirq |

**Ecosystem Project Card**:
- Project name and icon
- GitHub stars
- Category badge
- Description (2-3 lines)

**Project Detail Sheet**:
- Full description
- Quick Actions: Run Demo, Export Code, View GitHub
- Sample code preview

### 4.4 Profile Detail View

**Purpose**: User account and statistics.

| Section | Content |
|---------|---------|
| **Avatar** | User image or initials |
| **Stats** | Lessons, XP, Level, Streak |
| **Achievements** | Unlocked badges |
| **Subscription** | Current plan, expiry |
| **Account Actions** | Logout, Delete Account |

### 4.5 Settings Section

| Setting | Icon | Action |
|---------|------|--------|
| **Language** | globe | Opens LanguageSelectionSheet |
| **Notifications** | bell.fill | Opens web settings |
| **Appearance** | paintbrush.fill | Opens web settings |
| **Privacy** | lock.fill | Opens privacy policy |
| **Reset Tutorial** | arrow.counterclockwise | Resets onboarding |
| **Help & Support** | questionmark.circle.fill | Opens support page |
| **Subscription Info** | crown.fill | Opens SubscriptionInfoView |

### 4.6 Language Selection Sheet

| Language | Code | Flag |
|----------|------|------|
| English | en | US |
| Korean | ko | KR |
| Japanese | ja | JP |
| Chinese | zh-Hans | CN |
| German | de | DE |

**Behavior**: Real-time UI update without app restart.

### 4.7 Subscription Info View

**Purpose**: Explain Pro vs Premium features for non-subscribers.

| Section | Content |
|---------|---------|
| **Hero** | Crown icon, title, subtitle |
| **Tier Cards** | Pro vs Premium side-by-side |
| **Features List** | 5 premium features with descriptions |
| **CTA** | "Subscribe Now" button → PaywallView |

**Tier Comparison**:

| Tier | Price | Key Features |
|------|-------|--------------|
| **Pro** | $4.99/mo | Real QPU, All Templates, Priority Support |
| **Premium** | $9.99/mo | Pro + Error Correction, Industry Solutions |

### 4.8 App Info Section

| Info | Source |
|------|--------|
| App Name | "SwiftQuantum" |
| Version | `Bundle.main.infoDictionary["CFBundleShortVersionString"]` |
| Icon | SF Symbol "atom" |

---

## Subscription System

### PaywallView

**Tab-Based UI**:

| Tab | Content |
|-----|---------|
| **Compare** | Feature comparison table (Free/Pro/Premium) |
| **Pro** | Pro plan details and purchase |
| **Premium** | Premium plan details and purchase |

**Feature Comparison Table**:

| Feature | Free | Pro | Premium |
|---------|------|-----|---------|
| Quantum Circuits | ✓ | ✓ | ✓ |
| Local Simulation | ✓ | ✓ | ✓ |
| Academy (Basic) | ✓ | ✓ | ✓ |
| Academy (Full) | - | ✓ | ✓ |
| Real QPU Access | - | ✓ | ✓ |
| Industry Solutions | - | - | ✓ |
| Email Support | - | ✓ | ✓ |
| Priority Support | - | - | ✓ |

**Plan Cards**:

| Plan | Product ID | Price |
|------|------------|-------|
| Pro Monthly | com.swiftquantum.pro.monthly | $4.99 |
| Pro Yearly | com.swiftquantum.pro.yearly | $39.99 (33% off) |
| Premium Monthly | com.swiftquantum.premium.monthly | $9.99 |
| Premium Yearly | com.swiftquantum.premium.yearly | $79.99 (33% off) |

### StoreKit 2 Integration

**Purchase Flow**:
1. User selects plan
2. StoreKit 2 purchase initiated
3. Transaction verified locally
4. Backend verification via POST `/api/v1/payment/verify/transaction`
5. UI updated with premium badge

**Restore Purchases**: Single tap to restore previous purchases.

---

## Authentication System

### Login View

| Field | Validation |
|-------|------------|
| Email | Email format required |
| Password | 8+ characters |

**Actions**: Login, Forgot Password, Sign Up link

### Sign Up View

| Field | Validation |
|-------|------------|
| Username | 3-20 characters |
| Email | Email format required |
| Password | 8+ characters, 1 uppercase, 1 number |
| Confirm Password | Must match |

**Actions**: Create Account, Login link

### Password Reset View

| Field | Validation |
|-------|------------|
| Email | Email format required |

**Actions**: Send Reset Email, Back to Login

---

## Developer Mode (QA/QC)

**Activation**: Hidden, developer-only feature.

### Features

| Feature | Description |
|---------|-------------|
| **DEV Badge** | Pulsing red badge with tap count |
| **Log Overlay** | Full-screen real-time log viewer |
| **Statistics** | Success, Failed, Coming Soon, No Action counts |
| **Export** | Text report export |

### Logged Interactions

All button taps across all screens are logged with:
- Timestamp (HH:mm:ss.SSS)
- Screen name
- Element name
- Status (Success, Failed, Coming Soon, No Action)

---

## Localization

### Supported Languages

| Language | Code | Status |
|----------|------|--------|
| English | en | Default |
| Korean | ko | Full |
| Japanese | ja | Full |
| Chinese (Simplified) | zh-Hans | Full |
| German | de | Full |

### Localized Components

- All navigation labels and descriptions
- All button text and actions
- All form fields and validation messages
- All error messages and alerts
- All feature descriptions and explanations
- IBM Quantum Ecosystem project names and descriptions
- Subscription tiers, features, and pricing

### LocalizationManager

**Key Methods**:
```swift
LocalizationManager.shared.setLanguage(.korean)  // Set language
LocalizationManager.shared.string(forKey: "key") // Get string
LocalizationManager.shared.currentLanguage       // Get current
```

---

## Technical Specifications

### Minimum Requirements

| Requirement | Specification |
|-------------|---------------|
| iOS Version | 18.0+ |
| macOS Version | 15.0+ |
| Swift Version | 6.0 |
| Xcode Version | 16.0+ |

### Dependencies

| Package | Purpose |
|---------|---------|
| SwiftQuantum | Core quantum simulation |
| StoreKit 2 | In-app purchases |
| SafariServices | In-app web views |

### API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/v1/users/stats` | GET | User statistics |
| `/api/v1/users/xp` | POST | Add XP points |
| `/api/v1/users/lessons/complete` | POST | Complete lesson |
| `/api/v1/payment/verify/transaction` | POST | Verify purchase |

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| 2.2.4 | 2026-01-18 | Ecosystem localization, Subscription redesign |
| 2.2.3 | 2026-01-18 | Auth localization, Paywall redesign |
| 2.2.2 | 2026-01-17 | Bridge info toggle, Build fixes |
| 2.2.1 | 2026-01-16 | Real-time localization, Backend integration |
| 2.2.0 | 2026-01-13 | StoreKit 2, German localization |
| 2.1.1 | 2026-01-08 | Developer mode QA/QC |
| 2.1.0 | 2026-01-06 | 4-Hub navigation, Academy, Industry |
| 2.0.0 | 2026-01-05 | QuantumBridge integration |

---

*Documentation generated for SwiftQuantum v2.2.4*
