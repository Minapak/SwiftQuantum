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

## 🎓 Linear Algebra in Quantum Computing

SwiftQuantum is built on fundamental linear algebra concepts. Understanding these concepts will help you grasp quantum computing more deeply.

### Mathematical Foundations

#### 1. **Complex Numbers as Vectors** (`Complex.swift`)
- Complex numbers form a 2D vector space over real numbers
- Operations: vector addition, scalar multiplication, inner products
- **Learn more**: [Linear Algebra Visual Guide](https://eunminpark.hashnode.dev/reviews-linear-algebra-through-three-lenses-an-ios-developers-journey-with-3blue1brown)

```swift
let z1 = Complex(3.0, 4.0)  // Vector [3, 4] in ℂ
let magnitude = z1.magnitude // L2 norm: √(3² + 4²) = 5
let conjugate = z1.conjugate // For inner products
```

#### 2. **Qubits as State Vectors** (`Qubit.swift`)
- Qubits are 2D complex vectors in Hilbert space
- State: |ψ⟩ = α|0⟩ + β|1⟩ where |α|² + |β|² = 1
- Basis: {|0⟩ = [1,0]ᵀ, |1⟩ = [0,1]ᵀ}

```swift
// Linear combination of basis vectors
let qubit = Qubit(alpha: 0.6, beta: 0.8)  // 0.6|0⟩ + 0.8|1⟩

// Inner product gives probability (Born rule)
let prob0 = qubit.probability0  // |⟨0|ψ⟩|² = |0.6|² = 0.36
let prob1 = qubit.probability1  // |⟨1|ψ⟩|² = |0.8|² = 0.64
```

#### 3. **Quantum Gates as Matrices** (`QuantumGates.swift`)
- All gates are 2×2 unitary matrices
- Gate operation: |ψ'⟩ = U|ψ⟩ (matrix-vector multiplication)
- Unitary property: U†U = I (preserves normalization)

```swift
// Hadamard gate matrix:
// H = (1/√2) [1   1]
//            [1  -1]
let superposition = QuantumGates.hadamard(Qubit.zero)
// Transforms |0⟩ → (|0⟩ + |1⟩)/√2

// Pauli-X (NOT) gate matrix:
// X = [0  1]
//     [1  0]
let flipped = QuantumGates.pauliX(qubit)
// Swaps amplitudes: [α, β]ᵀ → [β, α]ᵀ
```

#### 4. **Circuits as Matrix Compositions** (`QuantumCircuit.swift`)
- Sequential gates = matrix multiplication
- Circuit: |ψ_final⟩ = U_n···U_2·U_1|ψ_initial⟩
- Order matters: matrix multiplication is non-commutative

```swift
let circuit = QuantumCircuit(qubit: .zero)
circuit.addGate(.hadamard)     // U₁ = H
circuit.addGate(.rotationZ(.pi/4))  // U₂ = RZ(π/4)
circuit.addGate(.hadamard)     // U₃ = H

// Executes: |ψ⟩ = H·RZ(π/4)·H|0⟩
let result = circuit.execute()
```

### Key Linear Algebra Concepts Used

| Concept | Quantum Computing Application | Code Example |
|---------|------------------------------|--------------|
| **Vector Space** | Qubits as vectors in ℂ² | `Qubit(alpha: 0.6, beta: 0.8)` |
| **Inner Product** | Measurement probabilities | `qubit.probability0` |
| **Normalization** | Valid quantum states | `\|\|ψ\|\| = 1` |
| **Unitary Matrix** | Reversible quantum gates | `U†U = I` |
| **Eigenvalues** | Measurement outcomes | `Z\|0⟩ = (+1)\|0⟩` |
| **Matrix Multiplication** | Gate sequences | `U₂(U₁\|ψ⟩)` |
| **Basis Change** | Different measurement bases | `H\|0⟩ → \|+⟩` |
| **Projection** | Quantum measurement | `P(\|0⟩) = \|⟨0\|ψ⟩\|²` |

### Visual Learning Resources

For a deeper, visual understanding of these linear algebra concepts:

📚 **[Linear Algebra Through Three Lenses: An iOS Developer's Journey with 3Blue1Brown](https://eunminpark.hashnode.dev/reviews-linear-algebra-through-three-lenses-an-ios-developers-journey-with-3blue1brown)**

This blog post explores:
- 🎨 **Geometric View**: Vectors as arrows, transformations as movements
- 🔢 **Numeric View**: Matrices as arrays of numbers, efficient computation
- 🧮 **Abstract View**: Vector spaces, linear maps, abstract algebra

Perfect for developers who want to understand the math behind quantum computing!

### Example: Understanding Hadamard Gate

```swift
// Mathematical perspective:
// H = (1/√2)[1   1] is a unitary matrix
//           [1  -1]
//
// Geometric perspective: 
// Rotates Bloch sphere 180° around (X+Z)/√2 axis
//
// Effect on basis:
// |0⟩ → (|0⟩ + |1⟩)/√2 = |+⟩  (to Hadamard basis)
// |1⟩ → (|0⟩ - |1⟩)/√2 = |−⟩

let qubit = Qubit.zero
let superposition = QuantumGates.hadamard(qubit)

print(superposition.probability0)  // 0.5 (50% chance)
print(superposition.probability1)  // 0.5 (50% chance)

// Bloch sphere coordinates
let (x, y, z) = superposition.blochCoordinates()
print("Position on Bloch sphere: (\(x), \(y), \(z))")
// Output: (1, 0, 0) - pointing along X-axis
```

### Learning Path

1. **Start with Complex Numbers** → Understand vector operations
2. **Study Qubits** → Learn about state vectors and inner products  
3. **Explore Quantum Gates** → See matrix transformations in action
4. **Build Circuits** → Master matrix composition
5. **Read the Blog** → Get visual intuition for the math

### Code Examples with Linear Algebra Annotations

```swift
// Example 1: Superposition (Linear Combination)
let superposition = Qubit(alpha: 1/sqrt(2), beta: 1/sqrt(2))
// |ψ⟩ = (1/√2)|0⟩ + (1/√2)|1⟩
// Equal probability: |⟨0|ψ⟩|² = |⟨1|ψ⟩|² = 0.5

// Example 2: Phase (Complex Amplitudes)
let phased = Qubit(
    amplitude0: Complex(1/sqrt(2), 0),
    amplitude1: Complex(0, 1/sqrt(2))
)
// |ψ⟩ = (1/√2)|0⟩ + (i/√2)|1⟩
// Relative phase = π/2

// Example 3: Gate Composition (Matrix Multiplication)
let circuit = QuantumCircuit(qubit: .zero)
circuit.addGate(.hadamard)        // H
circuit.addGate(.pauliZ)          // Z  
circuit.addGate(.hadamard)        // H

// Matrix calculation: H·Z·H = X (Pauli-X gate!)
// This is an example of basis change: Z in Hadamard basis = X
let result = circuit.execute()
// Equivalent to: QuantumGates.pauliX(.zero) = |1⟩

// Example 4: Rotation (Continuous Transformation)
let angle = Double.pi / 4  // 45 degrees
let rotated = QuantumGates.rotationY(Qubit.zero, angle: angle)
// RY(π/4) = [cos(π/8)  -sin(π/8)]
//           [sin(π/8)   cos(π/8)]
// Creates partial superposition based on angle
```

### Why Linear Algebra Matters

1. **🎯 Precise Predictions**: Linear algebra gives exact quantum probabilities
2. **🔧 Algorithm Design**: Understanding matrices helps design quantum algorithms  
3. **⚡ Optimization**: Matrix properties enable circuit optimization
4. **🧪 Debugging**: Linear algebra helps verify quantum operations
5. **📊 Visualization**: Bloch sphere and other geometric tools

### Further Reading

- **In Code**: Every quantum file has detailed linear algebra comments
- **In Blog**: [Visual explanations with 3Blue1Brown style](https://eunminpark.hashnode.dev/reviews-linear-algebra-through-three-lenses-an-ios-developers-journey-with-3blue1brown)
- **In Practice**: Run the tutorials to see linear algebra in action

```swift
// See linear algebra in action:
QuantumAlgorithmTutorials.superpositionTutorial()
QuantumAlgorithmTutorials.interferencePatternsTutorial()
```

---

*The beauty of quantum computing lies in the elegant mathematics of linear algebra. Understanding this foundation transforms quantum computing from mysterious to magnificent!* ✨

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

Connect: [LinkedIn](https://www.linkedin.com/in/eunminpark-ios) | [Blog](https://eunminpark.hashnode.dev)

---

Built with ❤️ for the quantum future of mobile computing.
