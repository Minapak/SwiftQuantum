//
//  QubitTests.swift
//  SwiftQuantumTests
//
//  Created by Eunmin Park on 2025-09-22.
//

import XCTest
@testable import SwiftQuantum

final class QubitTests: XCTestCase {
    
    func testQubitInitialization() {
        let qubit = Qubit(alpha: 0.6, beta: 0.8)
        
        XCTAssertEqual(qubit.probability0, 0.36, accuracy: 1e-15)
        XCTAssertEqual(qubit.probability1, 0.64, accuracy: 1e-15)
        XCTAssertTrue(qubit.isNormalized)
    }
    
    func testStandardStates() {
        // Test |0⟩ state
        let zero = Qubit.zero
        XCTAssertEqual(zero.probability0, 1.0, accuracy: 1e-15)
        XCTAssertEqual(zero.probability1, 0.0, accuracy: 1e-15)
        
        // Test |1⟩ state
        let one = Qubit.one
        XCTAssertEqual(one.probability0, 0.0, accuracy: 1e-15)
        XCTAssertEqual(one.probability1, 1.0, accuracy: 1e-15)
        
        // Test superposition state
        let superposition = Qubit.superposition
        XCTAssertEqual(superposition.probability0, 0.5, accuracy: 1e-15)
        XCTAssertEqual(superposition.probability1, 0.5, accuracy: 1e-15)
    }
    
    func testMeasurement() {
        let measurements = Qubit.superposition.measureMultiple(count: 10000)
        let count0 = measurements[0] ?? 0
        let count1 = measurements[1] ?? 0
        
        // Should be approximately 50-50 distribution
        XCTAssertEqual(Double(count0) / 10000.0, 0.5, accuracy: 0.05)
        XCTAssertEqual(Double(count1) / 10000.0, 0.5, accuracy: 0.05)
    }
    
    func testBlochCoordinates() {
        let zero = Qubit.zero
        let (x, y, z) = zero.blochCoordinates()
        
        XCTAssertEqual(x, 0.0, accuracy: 1e-15)
        XCTAssertEqual(y, 0.0, accuracy: 1e-15)
        XCTAssertEqual(z, 1.0, accuracy: 1e-15)
    }
    
    func testEntropy() {
        // Pure states should have zero entropy
        XCTAssertEqual(Qubit.zero.entropy(), 0.0, accuracy: 1e-15)
        XCTAssertEqual(Qubit.one.entropy(), 0.0, accuracy: 1e-15)
        
        // Superposition should have maximum entropy
        XCTAssertEqual(Qubit.superposition.entropy(), 1.0, accuracy: 1e-15)
    }
}
