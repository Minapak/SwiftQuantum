cat > CHANGELOG.md << 'EOF'
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
  - Extension methods for easy visualization
  
- **SuperpositionPlayground**: Interactive learning playground
  - Explore different superposition states
  - Custom superposition creator
  - Quantum collapse demonstration
  - Bloch sphere explorer
  - Quantum parallelism demo
  - State comparison tools
  
- **App Icon**: Custom designed icon featuring:
  - Personal identity (사주 오행 + 태몽)
  - Bloch sphere representation
  - Water element flow (37.5% 水)
  - Wood growth pattern (25% 木)
  - Technical grid and quantum visualization
  - All iOS required sizes (1024x1024 to 20x20)

### Changed
- **README.md**: Complete documentation overhaul
  - Added iOS app documentation
  - Added comprehensive examples
  - Added API reference links
  - Added screenshots section
  - Added performance benchmarks
  - Added roadmap
  
### Documentation
- Added tutorial series links
- Added blog post references
- Added contributing guidelines
- Added architecture documentation

## [1.0.0] - 2025-09-28

### Added
- Initial release of SwiftQuantum
- Complex number arithmetic
- Single-qubit quantum states
- Quantum gates (Pauli-X, Y, Z, Hadamard, Phase, T)
- Quantum circuits
- Measurement operations
- Bloch sphere calculations
- Comprehensive test suite
- Basic documentation

[1.1.0]: https://github.com/Minapak/SwiftQuantum/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Minapak/SwiftQuantum/releases/tag/v1.0.0
EOF

git add CHANGELOG.md
git commit -m "docs: Add CHANGELOG for version 1.1.0"
