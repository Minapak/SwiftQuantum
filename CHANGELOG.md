# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.2.1] - 2026-01-16

### Added
- **Real-time Language Switching**
  - Instant UI update without app restart
  - `LocalizationManager` with `@MainActor` localized properties
  - Fixed MainActor isolation issues in `QuantumHub` enum

- **Backend Integration for More Tab**
  - `UserStatsManager` for fetching user statistics from backend
  - `SafariWebView` for in-app web settings pages
  - Settings items (Notifications, Appearance, Privacy, Help) → web URLs
  - Quick Stats connected to backend with UserDefaults fallback

- **Dynamic Content (Hardcoded Values Removed)**
  - Academy badge: `"5 Lessons"` → `"\(lessonsCompleted) Done"` (dynamic)
  - Version info: `"2.1.1"` → `Bundle.main.infoDictionary` (dynamic)
  - Profile stats: Hardcoded → Backend API + cache fallback

- **Deep Linking**
  - Academy card → QuantumNative app via `quantumnative://academy`
  - Fallback to in-app Academy sheet if app not installed

- **Product Landing Page** (`Website/index.html`)
  - Hero section with app preview and feature highlights
  - Pricing section with subscription tier comparison
  - Research foundation section highlighting Harvard-MIT publications
  - Responsive design for mobile and desktop

- **Support Center** (`Website/support.html`)
  - FAQ section with common questions and answers
  - Contact form for user inquiries
  - Documentation links and resources

- **App Assets**
  - Complete iOS app icon set (all required sizes)
  - macOS app icon set
  - Custom splash screen with brand logo
  - LaunchScreen.storyboard with animated splash

### Changed
- **Localization System**
  - Added `@MainActor localizedTitle` and `localizedDescription` to `QuantumHub`
  - Added new `LocalizedStringKey` entries for Lab UI (Control, Measure, Probability, etc.)
  - Updated all 5 language dictionaries with new keys

- **Project Structure**
  - Removed deprecated files
  - Consolidated view files into organized directories
  - Cleaned up CI configuration files

### Fixed
- MainActor isolation error when accessing `LocalizationManager` from enum
- Tab bar showing English instead of localized language
- Duplicate `FeatureRow` struct declarations
- Xcode warnings for unused variables
- Unassigned asset catalog issues

---

## [2.2.0] - 2026-01-13

### Added
- **Backend Integration with Apple App Store Server API v2**
  - `APIClient.swift`: Complete backend API communication layer
  - JWT-based authentication with Apple's servers
  - Transaction verification flow from iOS to backend

- **StoreKit 2 Premium System**
  - `PremiumManager.swift`: Full StoreKit 2 integration with backend verification
  - Automatic transaction verification after purchase
  - Subscription status persistence and restoration

- **Content Access Management**
  - `ContentAccessManager.swift`: Granular content locking system
  - Level-based access control for academy content
  - Feature-based access for QuantumBridge and Industry solutions
  - `.premiumContent()` SwiftUI view modifier

- **PaywallView**: Professional subscription UI
  - Feature comparison between Pro and Premium tiers
  - Product selection with yearly savings badge
  - Purchase and restore functionality
  - Legal terms and privacy policy links

- **German Localization (de.lproj)**
  - Full translation for all UI strings
  - Now supporting 5 languages: EN, KO, JA, ZH-Hans, DE

- **Qiskit-Compatible DTO Layer**
  - `GateDTO.swift`: Data transfer object for quantum gates
  - `QuantumCircuitDTO.swift`: Serializable circuit representation
  - Network communication compatibility with backend services

### Changed
- **Bundle ID Update**: Changed to production bundle ID
- **App Rebranding**: QuantumAcademy → QuantumNative
  - Updated URL scheme
  - Renamed all related classes and view files

---

## [2.1.1] - 2026-01-08

### Added
- **Developer Mode QA/QC System**
  - `DeveloperModeManager.swift`: Complete interaction logging system
  - Pulsing red DEV badge in top-right corner with tap count
  - Full-screen log overlay with real-time statistics
  - Timestamped logs with HH:mm:ss.SSS precision

- **Comprehensive Button Tap Logging**
  - Lab: Mode Selector, Probability Slider, Gate Buttons (H/X/Y/Z), Measure, Reset
  - Presets: Category Filter, Preset Cards, Search Clear
  - Bridge: Connect/Disconnect, Backend Selection, Deploy, Quick Actions, Job Cancel
  - Academy: Level Selection, Start/Review Buttons, Close Detail
  - Industry: Solution Cards, ROI Calculate, Pricing Plans
  - Profile: Settings Button, Achievements, All Settings Toggles
  - More: Academy/Industry/Profile Cards, Language, Reset Tutorial
  - TabBar: All 4 Tab Navigations

- **Log Overlay Features**
  - Real-time statistics: Success/Failed/Coming Soon/No Action counts
  - Color-coded screen labels
  - Export capability for text reports
  - Clear function to reset log history

- **Enterprise Quantum Engine Upgrade**
  - Enhanced `QuantumExecutor.swift` with improved error handling
  - Optimized `LinearAlgebra.swift` with Accelerate framework
  - Updated `NoiseModel.swift` with Harvard-MIT 2025 parameters
  - `QuantumCircuitBuilder.swift` DSL improvements

### Changed
- **UX Enhancement**: English set as default language
- **Settings & Onboarding UX**: Improved user flow
- **Localization Updates**: Enhanced strings for EN, KO, JA, ZH-Hans

---

## [2.1.0] - 2026-01-06

### Added
- **QuantumExecutor Protocol** - Hybrid Execution System
  - `LocalQuantumExecutor`: Local simulation with optional error correction
  - `QuantumBridgeExecutor`: Real quantum hardware via IBM Quantum API
  - Unified interface for seamless switching between local and cloud execution
  - Fidelity metrics and error correction info in results

- **Fault-Tolerant Simulation** (Harvard-MIT 2025 Research)
  - Surface code error correction based on Nature 2025 publications
  - 448-qubit fault-tolerant architecture simulation
  - Sub-0.5% logical error rate modeling
  - Magic state distillation support

- **Premium 8-Tab UI Structure**
  | Tab | Name | Premium |
  |-----|------|---------|
  | 1 | Controls | Free |
  | 2 | Measure | Free |
  | 3 | Presets | Free |
  | 4 | Info | Free |
  | 5 | Bridge | Premium |
  | 6 | Examples | Free |
  | 7 | Industry | Premium |
  | 8 | Academy | Premium |

- **4-Hub Navigation** (Apple HIG Consolidation)
  - `LabHubView.swift`: Control + Measure + Info
  - `PresetsHubView.swift`: Presets + Examples
  - `FactoryHubView.swift`: Bridge (QPU connection)
  - `MoreHubView.swift`: Academy + Industry + Profile
  - `QuantumHorizonTabBar.swift`: Floating 4-tab navigation

- **Quantum Academy Subscription Platform**
  - MIT/Harvard research-based curriculum
  - Tracks: Fundamentals (Free), Algorithms, Hardware, Security (Premium)
  - Progress gamification: Streaks, XP, achievement badges
  - Level-based content unlocking

- **Industry Solutions B2B Module**
  - Portfolio Optimization (Finance): 100x speedup
  - Drug Discovery (Healthcare): 1000x speedup
  - Supply Chain Routing (Logistics): 50x speedup
  - Fraud Detection (Finance): 10x speedup
  - ROI calculator and pricing plans

- **Error Correction Visualization**
  - `ErrorCorrectionView.swift`: Visual representation of surface codes
  - Code distance and logical error rate display
  - Real-time fidelity metrics

### Changed
- **README Update**: Complete documentation overhaul for v2.0+

---

## [2.0.0] - 2026-01-05

### Added
- **QuantumBridge Integration**
  - `QuantumBridge.swift`: QASM 2.0 export capability
  - IBM Quantum configuration and API connectivity
  - Bridge circuit builder for hardware-compatible circuits
  - Job submission and result retrieval

- **QuantumBridgeConnectionView**
  - Real-time connection status display
  - Backend selection (IBM Brisbane, etc.)
  - Job queue monitoring
  - Circuit deployment interface

### Changed
- **Project Reorganization**
  - Replaced SwiftQuantumLearning with SwiftQuantumV2
  - New modular architecture for better maintainability

### Removed
- Deprecated SwiftQuantumLearning project

---

## [1.2.0] - 2025-12-29

### Added
- **Quantum Explorer UI Redesign**
  - Enhanced visualization with modern SwiftUI components
  - Improved Bloch sphere 3D rendering
  - New preset state cards with category filtering

- **Korean Localization for README**

- **New Screenshots**
  - Controls screenshot
  - 3D view screenshot
  - Info panel screenshot
  - Examples screenshot

### Changed
- **BlochSphereView3D**: Updated with advanced rendering features
- **README**: Enhanced layout with better content organization
- **Platform Support**: Revised documentation for iOS 18+ and macOS 15+

---

## [1.1.0] - 2025-09-30

### Added
- **iOS SuperpositionVisualizer App**: Complete iOS application for quantum state visualization
  - Interactive Bloch sphere with 3D effects and animations
  - Real-time probability and phase controls
  - Quantum measurement system with statistical histograms
  - Preset quantum states (|0⟩, |1⟩, |+⟩, |−⟩, |±i⟩)
  - Educational info section with quantum computing basics
  - Dark mode quantum-themed UI

- **QubitVisualizer**: Comprehensive visualization tools for quantum states
  - Bloch sphere ASCII visualization
  - Measurement histogram generation
  - State vector Dirac notation display
  - State comparison and fidelity calculation

- **SuperpositionPlayground**: Interactive learning playground

- **App Icon**: Custom designed icon with all iOS required sizes

### Changed
- **README.md**: Complete documentation overhaul
  - Added iOS app documentation
  - Added comprehensive examples
  - Added API reference links
  - Added performance benchmarks
  - Added roadmap

---

## [1.0.0] - 2025-09-28

### Added
- **Initial Release of SwiftQuantum**
- **Complex Number Arithmetic**
  - `Complex.swift`: Full complex number support
  - Addition, subtraction, multiplication, division
  - Conjugate, magnitude, phase operations

- **Single-Qubit Quantum States**
  - `Qubit.swift`: Quantum state representation
  - State vector with alpha and beta amplitudes
  - Normalization and validation

- **Quantum Gates**
  - `QuantumGates.swift`: Standard gate library
  - Pauli-X, Y, Z gates
  - Hadamard gate
  - Phase gate (S)
  - T gate (π/8)
  - Rotation gates (Rx, Ry, Rz)

- **Quantum Circuits**
  - `QuantumCircuit.swift`: Circuit composition
  - Sequential gate application
  - Circuit visualization

- **Measurement Operations**
  - Probabilistic collapse simulation
  - Statistical measurement with configurable shots
  - Measurement result histograms

- **Multi-Qubit Support**
  - `QuantumRegister.swift`: Up to 20 qubits
  - CNOT gate (controlled-NOT)
  - Toffoli gate (CCNOT)
  - SWAP gate
  - Tensor product operations

- **Quantum Algorithms**
  - `QuantumAlgorithms.swift`: Standard algorithms
  - Bell state preparation
  - GHZ state generation
  - Grover's search algorithm
  - Deutsch-Jozsa algorithm
  - Simon's algorithm
  - Quantum Fourier Transform

- **Comprehensive Test Suite**
  - Unit tests for all core components
  - Gate verification tests
  - Algorithm correctness tests

---

[2.2.1]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v2.2.0...v2.2.1
[2.2.0]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v2.1.1...v2.2.0
[2.1.1]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v2.1.0...v2.1.1
[2.1.0]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/YOUR_USERNAME/SwiftQuantum/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/YOUR_USERNAME/SwiftQuantum/releases/tag/v1.0.0
