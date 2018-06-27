//
//  EnumIteratorTests.swift
//  BaseAppV2UnitTests
//
//  Created by Emanuel  Guerrero on 1/2/18.
//  Copyright © 2018 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class EnumIteratorTests: BaseUnitTests {
    
    /// MARK: - Private Instance Attributes
    
    // swiftlint:disable identifier_name
    
    /// An enum that conforms to `EnumIterator`.
    enum Move: EnumIterator {
        case up
        case down
        case left
        case right
    }
    
    // swiftlint:enable identifier_name
}


// MARK: - Functional Tests
extension EnumIteratorTests {
    func testCaseAfter() {
        var move = Move.up
        move = Move.caseAfter(move)!
        XCTAssertEqual(move, .down, "Incorrect case returned!")
        move = Move.caseAfter(move)!
        XCTAssertEqual(move, .left, "Incorrect case returned!")
        move = Move.caseAfter(move)!
        XCTAssertEqual(move, .right, "Incorrect case returned!")
        move = Move.caseAfter(move)!
        XCTAssertEqual(move, .up, "Incorrect case returned!")
    }
    
    func testCaseBefore() {
        var move = Move.right
        move = Move.caseBefore(move)!
        XCTAssertEqual(move, .left, "Incorrect case returned!")
        move = Move.caseBefore(move)!
        XCTAssertEqual(move, .down, "Incorrect case returned!")
        move = Move.caseBefore(move)!
        XCTAssertEqual(move, .up, "Incorrect case returned!")
        move = Move.caseBefore(move)!
        XCTAssertEqual(move, .right, "Incorrect case returned!")
    }
}
