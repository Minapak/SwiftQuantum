//
//  QuantumApplications.swift
//  SwiftQuantum Examples
//
//  Real-world applications of quantum computing concepts
//  Created by Eunmin Park on 2025-09-22.
//

import Foundation
import SwiftQuantum

/// Practical quantum computing applications for iOS development
public class QuantumApplications {
    
    // MARK: - Quantum Random Number Generator
    
    /// High-quality quantum random number generator for cryptographic applications
    public class QuantumRNG {
        private let circuit = QuantumCircuit(qubit: .zero)
        
        public init() {
            circuit.addGate(.hadamard)
        }
        
        /// Generates a truly random bit using quantum superposition
        public func randomBit() -> Int {
            return circuit.executeAndMeasure()
        }
        
        /// Generates a random integer in the specified range
        public func randomInt(in range: ClosedRange<Int>) -> Int {
            let rangeSize = range.upperBound - range.lowerBound + 1
            let bitsNeeded = Int(ceil(log2(Double(rangeSize))))
            
            repeat {
                var result = 0
                for i in 0..<bitsNeeded {
                    let bit = randomBit()
                    result += bit * (1 << i)
                }
                
                if result < rangeSize {
                    return range.lowerBound + result
                }
            } while true
        }
        
        /// Generates random bytes for cryptographic use
        public func randomBytes(count: Int) -> [UInt8] {
            return (0..<count).map { _ in
                var byte: UInt8 = 0
                for i in 0..<8 {
                    byte |= UInt8(randomBit()) << i
                }
                return byte
            }
        }
        
        /// Generates a random UUID using quantum randomness
        public func randomUUID() -> UUID {
            let bytes = randomBytes(count: 16)
            return UUID(uuid: (
                bytes[0], bytes[1], bytes[2], bytes[3],
                bytes[4], bytes[5], bytes[6], bytes[7],
                bytes[8], bytes[9], bytes[10], bytes[11],
                bytes[12], bytes[13], bytes[14], bytes[15]
            ))
        }
        
        /// Tests the randomness quality of generated bits
        public func testRandomness(samples: Int = 10000) -> (entropy: Double, balance: Double) {
            var ones = 0
            var bits: [Int] = []
            
            for _ in 0..<samples {
                let bit = randomBit()
                bits.append(bit)
                if bit == 1 { ones += 1 }
            }
            
            let balance = abs(0.5 - Double(ones) / Double(samples))
            
            // Calculate entropy
            let p1 = Double(ones) / Double(samples)
            let p0 = 1.0 - p1
            let entropy = p0 > 0 && p1 > 0 ? -(p0 * log2(p0) + p1 * log2(p1)) : 0.0
            
            return (entropy: entropy, balance: balance)
        }
    }
    
    // MARK: - Quantum-Inspired Optimization
    
    /// Quantum-inspired optimization algorithms for solving complex problems
    public class QuantumOptimizer {
        
        /// Optimizes a simple function using quantum-inspired annealing
        public static func optimizeFunction(_ function: (Double) -> Double,
                                          in range: ClosedRange<Double>,
                                          iterations: Int = 1000) -> (value: Double, result: Double) {
            var bestX = range.lowerBound + (range.upperBound - range.lowerBound) / 2
            var bestValue = function(bestX)
            
            let rng = QuantumRNG()
            
            for iteration in 0..<iterations {
                // Quantum-inspired exploration
                let temperature = Double(iterations - iteration) / Double(iterations)
                
                // Use quantum randomness for exploration
                let randomOffset = (Double(rng.randomBit()) - 0.5) * 2.0 * temperature * (range.upperBound - range.lowerBound) * 0.1
                let newX = max(range.lowerBound, min(range.upperBound, bestX + randomOffset))
                let newValue = function(newX)
                
                // Accept better solutions or occasionally accept worse ones (quantum tunneling effect)
                let acceptanceProbability = newValue < bestValue ? 1.0 : exp(-(newValue - bestValue) / max(temperature, 0.01))
                
                if Double(rng.randomBit()) < acceptanceProbability {
                    bestX = newX
                    bestValue = newValue
                }
            }
            
            return (value: bestX, result: bestValue)
        }
        
        /// Solves the traveling salesman problem using quantum-inspired algorithms
        public static func solveTSP(distances: [[Double]]) -> [Int] {
            let n = distances.count
            var bestRoute = Array(0..<n)
            var bestDistance = calculateTotalDistance(route: bestRoute, distances: distances)
            
            let rng = QuantumRNG()
            let iterations = n * n * 10
            
            for iteration in 0..<iterations {
                var newRoute = bestRoute
                
                // Quantum-inspired mutation: swap two cities
                let i = rng.randomInt(in: 0...(n-1))
                let j = rng.randomInt(in: 0...(n-1))
                
                if i != j {
                    newRoute.swapAt(i, j)
                    
                    let newDistance = calculateTotalDistance(route: newRoute, distances: distances)
                    
                    // Accept improvement or use quantum tunneling
                    let temperature = Double(iterations - iteration) / Double(iterations)
                    let acceptanceProbability = newDistance < bestDistance ? 1.0 :
                        exp(-(newDistance - bestDistance) / (temperature * bestDistance * 0.1))
                    
                    if Double(rng.randomBit()) < acceptanceProbability {
                        bestRoute = newRoute
                        bestDistance = newDistance
                    }
                }
            }
            
            return bestRoute
        }
        
        private static func calculateTotalDistance(route: [Int], distances: [[Double]]) -> Double {
            var total = 0.0
            for i in 0..<route.count {
                let from = route[i]
                let to = route[(i + 1) % route.count]
                total += distances[from][to]
            }
            return total
        }
    }
    
    // MARK: - Quantum Machine Learning
    
    /// Quantum-inspired machine learning algorithms
    public class QuantumML {
        
        /// Simple quantum-inspired perceptron for binary classification
        public static func quantumPerceptron(training: [(features: [Double], label: Int)],
                                           learningRate: Double = 0.1,
                                           epochs: Int = 100) -> [Double] {
            let featureCount = training.first?.features.count ?? 0
            var weights = [Double](repeating: 0.0, count: featureCount + 1) // +1 for bias
            
            let rng = QuantumRNG()
            
            // Initialize weights with quantum randomness
            for i in 0..<weights.count {
                weights[i] = (Double(rng.randomBit()) - 0.5) * 2.0 * 0.1
            }
            
            for epoch in 0..<epochs {
                for (features, label) in training {
                    // Forward pass with quantum-inspired activation
                    let input = features + [1.0] // Add bias
                    let sum = zip(input, weights).map(*).reduce(0, +)
                    
                    // Quantum-inspired activation function using superposition concepts
                    let quantumCircuit = QuantumCircuit(qubit: .zero)
                    quantumCircuit.addGate(.hadamard)
                    quantumCircuit.addGate(.rotationY(sum))
                    
                    let finalState = quantumCircuit.execute()
                    let prediction = finalState.probability1 > 0.5 ? 1 : 0
                    
                    // Update weights based on error
                    if prediction != label {
                        let error = Double(label - prediction)
                        for i in 0..<weights.count {
                            weights[i] += learningRate * error * input[i]
                            
                            // Add quantum noise for exploration
                            let quantumNoise = (Double(rng.randomBit()) - 0.5) * 2.0 * 0.01
                            weights[i] += quantumNoise
                        }
                    }
                }
            }
            
            return weights
        }
        
        /// Quantum-inspired clustering algorithm
        public static func quantumClustering(points: [[Double]], k: Int, iterations: Int = 100) -> [[Double]] {
            let dimensions = points.first?.count ?? 0
            var centroids: [[Double]] = []
            let rng = QuantumRNG()
            
            // Initialize centroids with quantum randomness
            for _ in 0..<k {
                var centroid: [Double] = []
                for _ in 0..<dimensions {
                    // Use quantum superposition to explore the space
                    let quantumCircuit = QuantumCircuit(qubit: .zero)
                    quantumCircuit.addGate(.hadamard)
                    quantumCircuit.addGate(.rotationY(Double.random(in: 0...(2*.pi))))
                    
                    let state = quantumCircuit.execute()
                    let value = (state.probability1 - 0.5) * 4.0 // Scale to reasonable range
                    centroid.append(value)
                }
                centroids.append(centroid)
            }
            
            for _ in 0..<iterations {
                var newCentroids = Array(repeating: [Double](repeating: 0.0, count: dimensions), count: k)
                var counts = Array(repeating: 0, count: k)
                
                // Assign points to clusters using quantum-inspired distance
                for point in points {
                    var bestCluster = 0
                    var bestDistance = Double.infinity
                    
                    for (clusterIndex, centroid) in centroids.enumerated() {
                        let distance = quantumDistance(point, centroid)
                        if distance < bestDistance {
                            bestDistance = distance
                            bestCluster = clusterIndex
                        }
                    }
                    
                    counts[bestCluster] += 1
                    for i in 0..<dimensions {
                        newCentroids[bestCluster][i] += point[i]
                    }
                }
                
                // Update centroids with quantum fluctuations
                for i in 0..<k {
                    if counts[i] > 0 {
                        for j in 0..<dimensions {
                            newCentroids[i][j] /= Double(counts[i])
                            
                            // Add quantum fluctuation
                            let quantumNoise = (Double(rng.randomBit()) - 0.5) * 2.0 * 0.1
                            newCentroids[i][j] += quantumNoise
                        }
                    }
                }
                
                centroids = newCentroids
            }
            
            return centroids
        }
        
        private static func quantumDistance(_ p1: [Double], _ p2: [Double]) -> Double {
            // Quantum-inspired distance metric using quantum interference
            var sum = 0.0
            for i in 0..<p1.count {
                let diff = p1[i] - p2[i]
                
                // Create quantum superposition based on the difference
                let quantumCircuit = QuantumCircuit(qubit: .zero)
                quantumCircuit.addGate(.hadamard)
                quantumCircuit.addGate(.rotationY(abs(diff)))
                quantumCircuit.addGate(.hadamard)
                
                let state = quantumCircuit.execute()
                let quantumWeight = state.probability0 // Use quantum probability as weight
                
                sum += diff * diff * quantumWeight
            }
            return sqrt(sum)
        }
    }
    
    // MARK: - Quantum Cryptography Simulation
    
    /// Quantum Key Distribution (QKD) simulation
    public class QuantumCryptography {
        
        /// Simulates BB84 quantum key distribution protocol
        public static func bb84KeyDistribution(keyLength: Int) -> (aliceKey: [Int], bobKey: [Int], errorRate: Double) {
            let rng = QuantumRNG()
            
            var aliceKey: [Int] = []
            var bobKey: [Int] = []
            var errors = 0
            
            for _ in 0..<keyLength {
                // Alice prepares a qubit
                let aliceBit = rng.randomBit()
                let aliceBasis = rng.randomBit() // 0 = Z basis, 1 = X basis
                
                // Prepare qubit based on bit and basis
                var qubit: Qubit
                if aliceBasis == 0 { // Z basis
                    qubit = aliceBit == 0 ? .zero : .one
                } else { // X basis
                    qubit = aliceBit == 0 ? .superposition : .minusSuperposition
                }
                
                // Bob measures with random basis
                let bobBasis = rng.randomBit()
                var measuredBit: Int
                
                if bobBasis == aliceBasis {
                    // Same basis - Bob should get Alice's bit
                    measuredBit = qubit.measure()
                } else {
                    // Different basis - random result
                    let measurementCircuit = QuantumCircuit(qubit: qubit)
                    if bobBasis == 1 && aliceBasis == 0 {
                        measurementCircuit.addGate(.hadamard) // Rotate to X basis
                    } else if bobBasis == 0 && aliceBasis == 1 {
                        measurementCircuit.addGate(.hadamard) // Rotate to Z basis
                    }
                    measuredBit = measurementCircuit.executeAndMeasure()
                }
                
                // They only keep bits where they used the same basis
                if aliceBasis == bobBasis {
                    aliceKey.append(aliceBit)
                    bobKey.append(measuredBit)
                    
                    if aliceBit != measuredBit {
                        errors += 1
                    }
                }
            }
            
            let errorRate = aliceKey.isEmpty ? 0.0 : Double(errors) / Double(aliceKey.count)
            return (aliceKey: aliceKey, bobKey: bobKey, errorRate: errorRate)
        }
        
        /// Quantum One-Time Pad encryption
        public static func quantumOneTimePad(message: String, keyLength: Int? = nil) -> (encrypted: [Int], key: [Int]) {
            let rng = QuantumRNG()
            let messageBytes = Array(message.utf8)
            let length = keyLength ?? messageBytes.count
            
            // Generate quantum random key
            let key = (0..<length).map { _ in rng.randomBit() }
            
            // Encrypt message
            var encrypted: [Int] = []
            for (index, byte) in messageBytes.enumerated() {
                if index < key.count {
                    encrypted.append(Int(byte) ^ key[index])
                } else {
                    encrypted.append(Int(byte))
                }
            }
            
            return (encrypted: encrypted, key: key)
        }
    }
    
    // MARK: - Demo Functions
    
    /// Comprehensive demonstration of quantum applications
    public static func demonstrateApplications() {
        print("🔮 Quantum Computing Applications for iOS")
        print("=========================================\n")
        
        // 1. Quantum RNG Demo
        print("1. Quantum Random Number Generator:")
        let rng = QuantumRNG()
        let randomNumbers = (0..<10).map { _ in rng.randomInt(in: 1...100) }
        print("Random numbers: \(randomNumbers)")
        
        let randomnessTest = rng.testRandomness(samples: 1000)
        print("Randomness quality - Entropy: \(String(format: "%.4f", randomnessTest.entropy)), Balance: \(String(format: "%.4f", randomnessTest.balance))")
        
        let quantumUUID = rng.randomUUID()
        print("Quantum UUID: \(quantumUUID)")
        print()
        
        // 2. Optimization Demo
        print("2. Quantum-Inspired Optimization:")
        let optimizationResult = QuantumOptimizer.optimizeFunction({ x in (x - 2) * (x - 2) + 1 },
                                                                 in: -10...10,
                                                                 iterations: 500)
        print("Optimized function f(x) = (x-2)² + 1")
        print("Minimum at x = \(String(format: "%.4f", optimizationResult.value)), f(x) = \(String(format: "%.4f", optimizationResult.result))")
        print()
        
        // 3. Machine Learning Demo
        print("3. Quantum-Inspired Machine Learning:")
        let trainingData = [
            (features: [0.0, 0.0], label: 0),
            (features: [0.0, 1.0], label: 1),
            (features: [1.0, 0.0], label: 1),
            (features: [1.0, 1.0], label: 0)  // XOR problem
        ]
        
        let weights = QuantumML.quantumPerceptron(training: trainingData, learningRate: 0.5, epochs: 100)
        print("Trained quantum perceptron for XOR problem")
        print("Weights: \(weights.map { String(format: "%.3f", $0) })")
        print()
        
        // 4. Cryptography Demo
        print("4. Quantum Cryptography Simulation:")
        let qkdResult = QuantumCryptography.bb84KeyDistribution(keyLength: 50)
        print("BB84 Quantum Key Distribution:")
        print("Alice's key: \(qkdResult.aliceKey.prefix(10))... (length: \(qkdResult.aliceKey.count))")
        print("Bob's key:   \(qkdResult.bobKey.prefix(10))... (length: \(qkdResult.bobKey.count))")
        print("Error rate: \(String(format: "%.2f%%", qkdResult.errorRate * 100))")
        
        let message = "Hello Quantum!"
        let encryption = QuantumCryptography.quantumOneTimePad(message: message)
        print("\nQuantum One-Time Pad:")
        print("Message: '\(message)'")
        print("Encrypted: \(encryption.encrypted.prefix(10))...")
        print("Key: \(encryption.key.prefix(10))...")
        print()
        
        print("✨ These applications demonstrate practical uses of quantum concepts in iOS development!")
    }
}
