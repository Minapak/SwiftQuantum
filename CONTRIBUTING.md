# Contributing to SwiftQuantum

Thank you for your interest in contributing to SwiftQuantum! This project brings quantum computing to iOS development, and we welcome contributions from developers of all backgrounds - whether you're a quantum computing expert or an iOS developer curious about quantum concepts.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contributing Guidelines](#contributing-guidelines)
- [Testing](#testing)
- [Documentation](#documentation)
- [Quantum Computing Guidelines](#quantum-computing-guidelines)
- [Code Style](#code-style)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Community and Support](#community-and-support)

## Code of Conduct

This project adheres to a Code of Conduct that we expect all contributors to follow:

- **Be respectful**: Treat everyone with respect and kindness
- **Be inclusive**: Welcome newcomers and diverse perspectives
- **Be constructive**: Focus on helping the project grow
- **Be patient**: Remember that quantum computing concepts can be complex
- **Be collaborative**: Work together to solve problems

## Getting Started

### Prerequisites

- **Xcode 15.0+** with Swift 6.0 support
- **macOS 14.0+** for development
- Basic understanding of iOS/Swift development
- Interest in quantum computing (we'll help with the rest!)

### Quick Setup

```bash
# Clone the repository
git clone https://github.com/Minapak/SwiftQuantum.git
cd SwiftQuantum

# Build the project
swift build

# Run tests
swift test

# Open in Xcode (optional)
open Package.swift
```

## Development Setup

### 1. Fork and Clone

```bash
# Fork the repository on GitHub, then:
git clone https://github.com/YOUR_USERNAME/SwiftQuantum.git
cd SwiftQuantum
git remote add upstream https://github.com/Minapak/SwiftQuantum.git
```

### 2. Install Development Tools

```bash
# Install SwiftLint for code formatting
brew install swiftlint

# Install SwiftFormat (optional but recommended)
brew install swiftformat
```

### 3. Verify Setup

```bash
# Run all tests
swift test

# Check code style
swiftlint

# Build release version
swift build -c release
```

## Contributing Guidelines

### Types of Contributions We Welcome

1. **🐛 Bug Fixes**
   - Fixing quantum calculation errors
   - Resolving performance issues
   - Correcting documentation mistakes

2. **✨ New Features**
   - Additional quantum gates
   - New quantum algorithms
   - Performance optimizations
   - Platform support improvements

3. **📚 Documentation**
   - API documentation improvements
   - Tutorial content
   - Example applications
   - Quantum computing education

4. **🧪 Testing**
   - Unit test improvements
   - Performance benchmarks
   - Edge case coverage
   - Integration tests

5. **🎨 Examples and Demos**
   - Practical applications
   - Educational content
   - SwiftUI integrations
   - Real-world use cases

### What We're Looking For

- **Quantum Algorithms**: Implementations of well-known quantum algorithms
- **Performance Improvements**: Optimizations for mobile devices
- **Educational Content**: Clear explanations and examples
- **Platform Features**: iOS-specific integrations and optimizations
- **Testing**: Comprehensive test coverage and edge cases

## Testing

### Running Tests

```bash
# Run all tests
swift test

# Run specific test suite
swift test --filter SwiftQuantumTests

# Run performance benchmarks
swift test --filter SwiftQuantumBenchmarks

# Run tests with coverage (if available)
swift test --enable-code-coverage
```

### Test Requirements

- **Unit Tests**: All public APIs must have unit tests
- **Integration Tests**: Complex features need integration testing
- **Performance Tests**: Critical paths should have benchmarks
- **Edge Cases**: Test boundary conditions and error states

### Writing Good Tests

```swift
import XCTest
@testable import SwiftQuantum

class YourFeatureTests: XCTestCase {
    
    func testBasicFunctionality() {
        // Arrange
        let input = Qubit.zero
        
        // Act
        let result = QuantumGates.hadamard(input)
        
        // Assert
        XCTAssertEqual(result.probability0, 0.5, accuracy: 1e-15)
        XCTAssertEqual(result.probability1, 0.5, accuracy: 1e-15)
        XCTAssertTrue(result.isNormalized)
    }
    
    func testQuantumProperty() {
        // Test that quantum properties are preserved
        let qubit = Qubit.random()
        let transformed = YourQuantumGate.apply(to: qubit)
        
        // Quantum states must remain normalized
        XCTAssertTrue(transformed.isNormalized)
        
        // Check specific quantum properties
        let (prob0, prob1) = (transformed.probability0, transformed.probability1)
        XCTAssertEqual(prob0 + prob1, 1.0, accuracy: 1e-14)
    }
}
```

## Documentation

### Documentation Standards

- **API Documentation**: All public APIs need comprehensive documentation
- **Code Examples**: Include practical usage examples
- **Mathematical Background**: Explain quantum concepts clearly
- **Performance Notes**: Document performance characteristics

### Writing Documentation

```swift
/// Applies the Hadamard gate to create equal superposition
///
/// The Hadamard gate is fundamental in quantum computing, transforming:
/// - |0⟩ → (|0⟩ + |1⟩)/√2
/// - |1⟩ → (|0⟩ - |1⟩)/√2
///
/// ## Mathematical Representation
/// ```
/// H = (1/√2) |1   1|
///            |1  -1|
/// ```
///
/// ## Example Usage
/// ```swift
/// let qubit = Qubit.zero
/// let superposition = QuantumGates.hadamard(qubit)
/// print(superposition.probability0) // 0.5
/// print(superposition.probability1) // 0.5
/// ```
///
/// - Parameter qubit: The input qubit state to transform
/// - Returns: A qubit in superposition state
/// - Complexity: O(1)
public static func hadamard(_ qubit: Qubit) -> Qubit {
    // Implementation...
}
```

## Quantum Computing Guidelines

### Quantum Accuracy Requirements

- **Normalization**: Quantum states must always be normalized
- **Unitarity**: Gates must preserve quantum state normalization
- **Precision**: Use high-precision arithmetic (1e-14 tolerance typically)
- **Mathematical Correctness**: Implement standard quantum formulas accurately

### Implementing Quantum Gates

```swift
public static func yourQuantumGate(_ qubit: Qubit, parameter: Double) -> Qubit {
    // 1. Validate input
    guard qubit.isNormalized else {
        fatalError("Input qubit must be normalized")
    }
    
    // 2. Apply quantum transformation
    let newAmplitude0 = // Your quantum calculation
    let newAmplitude1 = // Your quantum calculation
    
    // 3. Create result (automatic normalization)
    let result = Qubit(amplitude0: newAmplitude0, amplitude1: newAmplitude1)
    
    // 4. Verify output (in debug builds)
    assert(result.isNormalized, "Output qubit must be normalized")
    
    return result
}
```

### Quantum Algorithm Implementation

1. **Research Phase**: Understand the algorithm thoroughly
2. **Mathematical Formulation**: Write down the quantum circuit
3. **Step-by-step Implementation**: Break down into basic gates
4. **Testing**: Verify against known results
5. **Documentation**: Explain the algorithm clearly

## Code Style

### Swift Style Guidelines

We follow Apple's Swift style guidelines with some quantum-specific adaptations:

```swift
// ✅ Good: Clear quantum state naming
let superpositionState = QuantumGates.hadamard(initialQubit)
let measurementResult = superpositionState.measure()

// ❌ Bad: Unclear variable names
let s = QuantumGates.hadamard(q)
let r = s.measure()

// ✅ Good: Mathematical precision
XCTAssertEqual(probability, expectedValue, accuracy: 1e-15)

// ❌ Bad: Insufficient precision
XCTAssertEqual(probability, expectedValue, accuracy: 0.01)
```

### SwiftLint Configuration

We use SwiftLint to maintain consistent code style. Run before committing:

```bash
swiftlint
swiftformat . # If you have SwiftFormat installed
```

### Quantum-Specific Style

- **Complex Numbers**: Use descriptive names (`amplitude0`, `amplitude1`)
- **Angles**: Always specify units (`angleInRadians`, not just `angle`)
- **Probabilities**: Use `probability0`/`probability1` naming
- **Gates**: Follow standard quantum gate naming conventions

## Pull Request Process

### Before You Start

1. **Check Existing Issues**: Look for related issues or discussions
2. **Create an Issue**: Describe what you plan to implement
3. **Get Feedback**: Discuss your approach with maintainers
4. **Fork and Branch**: Create a feature branch from `main`

### PR Requirements

1. **✅ Tests Pass**: All existing tests must pass
2. **✅ New Tests**: Add tests for new functionality  
3. **✅ Documentation**: Update docs for API changes
4. **✅ Code Style**: Follow SwiftLint guidelines
5. **✅ Performance**: No significant performance regressions

### PR Template

```markdown
## Description
Brief description of changes and motivation.

## Type of Change
- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)  
- [ ] Breaking change (fix or feature that causes existing functionality to change)
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated  
- [ ] Performance tests added/updated
- [ ] Manual testing completed

## Quantum Computing Validation
- [ ] Mathematical accuracy verified
- [ ] Quantum properties preserved (normalization, unitarity)
- [ ] Edge cases considered
- [ ] Algorithm correctness validated

## Checklist
- [ ] Code follows SwiftLint style guidelines
- [ ] Self-review of code completed
- [ ] Documentation updated
- [ ] Tests added and passing
- [ ] No breaking changes (or clearly documented)
```

### Review Process

1. **Automated Checks**: CI/CD pipeline runs automatically
2. **Code Review**: Maintainers review code and approach
3. **Testing**: Manual testing of new features
4. **Quantum Validation**: Verification of quantum correctness
5. **Documentation Review**: Ensure docs are clear and accurate

## Issue Reporting

### Bug Reports

When reporting bugs, please include:

```markdown
**Environment:**
- iOS version:
- Xcode version:
- SwiftQuantum version:

**Description:**
Clear description of the bug.

**Steps to Reproduce:**
1. Create quantum circuit...
2. Apply gates...
3. Measure results...

**Expected Behavior:**
What should happen.

**Actual Behavior:**
What actually happens.

**Code Sample:**
```swift
// Minimal code that reproduces the issue
let circuit = QuantumCircuit(qubit: .zero)
// ... rest of code
```

**Additional Context:**
- Quantum algorithm being implemented
- Performance implications
- Screenshots (if applicable)
```

### Feature Requests

When requesting features, please include:

- **Quantum Algorithm**: Which quantum algorithm or concept
- **Use Case**: How it would be used in iOS development
- **Mathematical Background**: Links to papers or explanations
- **Implementation Ideas**: Suggestions for implementation approach

## Community and Support

### Communication Channels

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General questions and ideas
- **Documentation**: In-code documentation and README
- **Examples**: Practical code examples and tutorials

### Getting Help

1. **Check Documentation**: Start with README and API docs
2. **Search Issues**: Look for similar questions
3. **Ask Questions**: Create a GitHub Discussion
4. **Join Community**: Connect with other contributors

### Recognition

We believe in recognizing contributions:

- **Contributors**: Listed in README and CHANGELOG
- **Significant Contributions**: Special recognition in releases
- **Expert Contributors**: Invitation to core team discussions

## Development Philosophy

### Our Values

- **Educational**: Making quantum computing accessible
- **Practical**: Focusing on real iOS development needs  
- **Accurate**: Maintaining quantum correctness
- **Performant**: Optimizing for mobile devices
- **Inclusive**: Welcoming all skill levels

### Quality Standards

- **Correctness**: Quantum algorithms must be mathematically correct
- **Performance**: Suitable for mobile device constraints
- **Usability**: Clear APIs that iOS developers can understand
- **Maintainability**: Well-structured, documented code

---

## Getting Started Checklist

- [ ] Read this contributing guide
- [ ] Set up development environment
- [ ] Run existing tests successfully  
- [ ] Browse issues for "good first issue" labels
- [ ] Join GitHub Discussions for questions
- [ ] Make your first contribution!

Thank you for contributing to SwiftQuantum! Together, we're bringing the quantum future to iOS development. 🚀⚛️

---

*For questions about contributing, please create a GitHub Discussion or reach out to the maintainers.*
