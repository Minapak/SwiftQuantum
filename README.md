# SwiftQuantum

A pure Swift framework for quantum computing on iOS, macOS, and other Apple platforms.

## Overview

SwiftQuantum brings quantum computing concepts to iOS development with a clean, Swift-native API. Built by a Senior iOS Developer with 6 years of experience, this framework provides the building blocks for quantum algorithms and simulations.

## Features

- **Complex Number Operations**: Full arithmetic support for quantum state calculations
- **Qubit Implementation**: Quantum bit states with superposition and measurement
- **Quantum Gates**: Essential gates including Hadamard, Pauli, and rotation gates
- **Quantum Circuits**: Compose and execute quantum algorithms
- **Pure Swift**: No external dependencies, optimized for Apple platforms
- **Unit Tested**: Comprehensive test coverage for all components

## Installation

### Swift Package Manager

Add SwiftQuantum to your project via Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/Minapak/SwiftQuantum.git`

Or add to your Package.swift:
```swift
dependencies: [
    .package(url: "https://github.com/Minapak/SwiftQuantum.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftQuantum

// Create a qubit in superposition
let qubit = Qubit.zero
let superposition = QuantumGates.hadamard(qubit)

// Measure the quantum state
let result = superposition.measure()
print("Measurement result: \(result)") // 0 or 1 with 50% probability each

// Create and execute a quantum circuit
let circuit = QuantumCircuit(qubit: .zero)
circuit.addGate(.hadamard)
circuit.addGate(.rotationZ(.pi/4))

let finalState = circuit.execute()
print("Final quantum state: \(finalState)")
```

## Core Components

### Complex Numbers
```swift
let c1 = Complex(3.0, 4.0)  // 3 + 4i
let c2 = Complex(1.0, 2.0)  // 1 + 2i
let sum = c1 + c2           // 4 + 6i
let magnitude = c1.magnitude // 5.0
```

### Quantum States
```swift
// Basic states
let zero = Qubit.zero           // |0⟩
let one = Qubit.one            // |1⟩
let plus = Qubit.superposition // (|0⟩ + |1⟩)/√2

// Custom states
let custom = Qubit(alpha: 0.6, beta: 0.8)
print("P(0) = \(custom.probability0)") // 0.36
print("P(1) = \(custom.probability1)") // 0.64
```

### Quantum Gates
```swift
// Single-qubit gates
let flipped = QuantumGates.pauliX(qubit)        // NOT gate
let rotated = QuantumGates.rotationY(qubit, angle: .pi/4)
let phased = QuantumGates.sGate(qubit)          // Phase gate

// Gate verification
let normalized = QuantumGates.hadamard(QuantumGates.hadamard(qubit))
// Should return original state (H² = I)
```

## Examples

### Quantum Random Number Generator
```swift
func quantumRandomBit() -> Int {
    let circuit = QuantumCircuit(qubit: .zero)
    circuit.addGate(.hadamard)
    return circuit.executeAndMeasure()
}

let randomBits = (0..<10).map { _ in quantumRandomBit() }
print("Random bits: \(randomBits)")
```

### Deutsch Algorithm (Simplified)
```swift
func deutschAlgorithm(isConstant: Bool) -> Bool {
    let circuit = QuantumCircuit(qubit: .zero)
    
    circuit.addGate(.hadamard)              // Create superposition
    
    if !isConstant {
        circuit.addGate(.pauliX)            // Balanced function
    }
    
    circuit.addGate(.hadamard)              // Interference
    
    let measurements = circuit.measureMultiple(shots: 100)
    return (measurements[0] ?? 0) > 50      // True if constant
}
```

## Requirements

- iOS 17.0+
- macOS 14.0+
- Xcode 15.0+
- Swift 5.9+

## Testing

Run the test suite:
```bash
swift test
```

Or test in Xcode with ⌘+U.

## Roadmap

- [ ] Multi-qubit systems and entanglement
- [ ] Quantum Fourier Transform
- [ ] Grover's search algorithm
- [ ] Shor's factoring algorithm
- [ ] Quantum error correction
- [ ] SwiftUI visualization components
- [ ] Performance optimizations

## Contributing

Contributions are welcome! Please read the contribution guidelines and submit pull requests for any improvements.

## License

MIT License - see LICENSE file for details.

## Author

**Eunmin Park**  
Senior iOS Developer & CTO  
6 years of iOS development experience  
Patent holder in AI-based systems

Connect: [LinkedIn](https://linkedin.com/in/eunminpark) | [Blog](https://eunminpark.hashnode.dev)

---

Built with ❤️ for the quantum future of mobile computing.
