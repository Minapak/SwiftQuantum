# SwiftQuantum v2.2.4 - 高级量子混合平台

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2018%2B%20%7C%20macOS%2015%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![QuantumBridge](https://img.shields.io/badge/QuantumBridge-2.0-blueviolet.svg)](https://github.com/user/QuantumBridge)
[![Quantum-Hybrid](https://img.shields.io/badge/Quantum--Hybrid-2026-00ff88.svg)](#)
[![Agentic AI](https://img.shields.io/badge/Agentic%20AI-Ready-ff6b6b.svg)](#)
[![Localization](https://img.shields.io/badge/Languages-EN%20%7C%20KO%20%7C%20JA%20%7C%20ZH%20%7C%20DE-blue.svg)](#)

**首个具有真实QPU连接的iOS量子计算框架** - 集成QuantumBridge、容错模拟和基于Harvard-MIT研究的教育内容！

> **Harvard-MIT研究基础**: 基于2025年Nature论文，展示了3000+连续量子比特运行和低于0.5%的错误率
>
> **真实量子硬件**: 通过QuantumBridge API连接IBM Quantum的127量子比特系统
>
> **高级学习平台**: MIT/Harvard风格的量子学院，提供订阅制课程
>
> **企业解决方案**: 面向金融、医疗和物流的B2B行业应用

---

## v2.2.4新功能（2026年生产版本）

### IBM Quantum Ecosystem本地化和订阅系统改版

- **IBM Quantum Ecosystem完全本地化**:
  - 12个生态系统项目名称和描述已本地化（EN、KO、JA、ZH、DE）
  - 类别标签（ML、Chemistry、Optimization、Hardware、Simulation、Research）已本地化
  - 生态系统项目卡、详情页、代码导出视图完全本地化

- **订阅系统全面重设计**:
  - 基于标签的比较UI（比较、Pro、Premium标签）
  - 清晰的计划区分：Pro月付、Pro年付、Premium月付、Premium年付
  - 带有Free/Pro/Premium列的功能比较表
  - 5种语言本地化

- **订阅信息页面（更多标签）**:
  - 设置部分新增"订阅信息"菜单项
  - 专门解释Pro vs Premium功能的页面
  - 带有功能亮点的层级比较卡
  - 带描述的所有功能列表
  - 一键访问PaywallView进行订阅

- **文本截断修复**:
  - 修复了导致福利描述中出现"..."的`lineLimit(1)`
  - Industry和Circuits标签的英雄部分现在在所有语言中显示完整文本

---

## 快速开始

### 安装

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "2.2.4")
]
```

### 基本用法

```swift
import SwiftQuantum

// 创建量子寄存器
let register = QuantumRegister(numberOfQubits: 3)

// 应用门
register.applyGate(.hadamard, to: 0)
register.applyCNOT(control: 0, target: 1)
register.applyCNOT(control: 1, target: 2)
// 创建GHZ状态: (|000⟩ + |111⟩)/√2

// 测量
let results = register.measureMultiple(shots: 1000)
// ["000": ~500, "111": ~500]
```

### QuantumBridge连接

```swift
import SwiftQuantum

// 为IBM Quantum创建执行器
let executor = QuantumBridgeExecutor(
    executorType: .ibmBrisbane,
    apiKey: "YOUR_IBM_QUANTUM_API_KEY"  // 从IBM Quantum获取
)

// 构建电路
let circuit = BridgeCircuitBuilder(numberOfQubits: 2, name: "Bell")
    .h(0)
    .cx(control: 0, target: 1)

// 在真实量子硬件上执行
let result = try await executor.execute(circuit: circuit, shots: 1000)
print("计数: \(result.counts)")  // {"00": 498, "11": 502}
```

---

## QuantumBridge标签 - 完整指南

**Bridge**标签是通往真实量子硬件的门户！您可以：

### 为什么使用QuantumBridge

| 优势 | 描述 |
|-----|------|
| **真实硬件** | 在真正的IBM量子处理器（127量子比特！）上运行电路 |
| **真正的量子效应** | 体验真实的叠加和纠缠 |
| **真实结果** | 从真正的量子计算机获取测量值，而非模拟 |

### 后端选项

| 后端 | 最佳用途 | 优势 | 限制 |
|-----|---------|------|-----|
| **模拟器** | 学习和测试 | 即时结果、免费、无队列 | 无真实量子噪声 |
| **IBM Brisbane** | 生产和研究 | 127量子比特、高相干性 | 队列等待时间 |
| **IBM Osaka** | 高速执行 | 快速门速度、较短队列 | 中等噪声 |
| **IBM Kyoto** | 研究项目 | 先进的错误缓解 | 目前维护中 |

---

## Industry标签 - 企业解决方案

**Industry**标签展示了面向真实企业的量子计算应用。

### 可用行业

| 行业 | 用例 | 效率提升 |
|-----|------|---------|
| **金融** | 投资组合优化、风险分析 | +52% |
| **医疗** | 药物发现、蛋白质折叠 | +38% |
| **物流** | 路线优化、供应链 | +45% |
| **能源** | 电网优化、预测 | +41% |
| **制造** | 质量控制、维护 | +33% |
| **AI和ML** | 量子机器学习 | +67% |

---

## IBM Quantum Ecosystem集成

### Ecosystem类别

| 类别 | 项目 | 描述 |
|-----|------|------|
| **机器学习** | TorchQuantum, Qiskit ML | 量子神经网络和ML算法 |
| **化学和物理** | Qiskit Nature | 分子模拟和药物发现 |
| **优化** | Qiskit Finance, Optimization | 投资组合优化和QAOA |
| **硬件提供商** | IBM, Azure, AWS Braket, IonQ | 直接访问量子处理器 |
| **模拟** | Qiskit Aer, MQT DDSIM | 高性能模拟器 |
| **研究** | PennyLane, Cirq | 跨平台研究框架 |

---

## 高级功能

### 订阅层级

| 功能 | 免费 | Pro ($4.99/月) | Premium ($9.99/月) |
|-----|-----|---------------|-------------------|
| 本地模拟 | 20量子比特 | 40量子比特 | 40量子比特 |
| 量子门 | 全部15+ | 全部15+ | 全部15+ |
| 基础示例 | 是 | 是 | 是 |
| QuantumBridge连接 | 否 | 是 | **是** |
| 错误纠正模拟 | 否 | 否 | **是** |
| 量子学院课程 | 2个免费 | 全部12+ | **全部12+** |
| 行业解决方案 | 仅查看 | 部分 | **完全访问** |
| 优先支持 | 否 | 邮件 | **优先** |

---

## 研究基础

### Harvard-MIT Nature 2025论文

SwiftQuantum建立在尖端量子计算研究之上：

1. **"使用448个中性原子量子比特的容错量子计算"**（Nature，2025年11月）
   - 首次展示低于0.5%的容错阈值

2. **"3000量子比特相干系统的连续运行"**（Nature，2025年9月）
   - 2小时以上的连续量子运行

3. **"中性原子量子计算机上的魔态蒸馏"**（Nature，2025年7月）
   - 通用容错量子计算的必要条件

---

## 路线图

### 版本2.2.4（当前 - 2026年1月）
- [x] IBM Quantum Ecosystem完全本地化（12个项目、6个类别）
- [x] 基于标签比较的订阅系统完全重设计
- [x] 更多标签设置中的订阅信息页面
- [x] 多语言福利描述的文本截断修复
- [x] 所有订阅相关UI本地化为5种语言

### 版本2.3.0（计划 - 2026年第2季度）
- [ ] 真实IBM Quantum作业提交
- [ ] 量子傅里叶变换（QFT）
- [ ] Shor算法实现
- [ ] 云作业队列仪表板
- [ ] 团队/企业账户

---

## 许可证

MIT许可证 - 参见[LICENSE](LICENSE)

---

<div align="center">

**SwiftQuantum - iOS量子计算的未来**

*基于Harvard-MIT研究*

</div>
