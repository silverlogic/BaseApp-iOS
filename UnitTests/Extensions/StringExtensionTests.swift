//
//  StringExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/21/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class StringExtensionTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testTruncate() {
        let shortSentence = "Short sentence"
        let longSentence = "This is a sentence longer than 20 characters"
        let noSentence = ""
        let truncatedShortSentence = shortSentence.truncate(length: 20)
        let truncatedLongSentence = longSentence.truncate(length: 20)
        let truncatedNoSentence = noSentence.truncate(length: 20)
        XCTAssertTrue(truncatedShortSentence.count == 14, "Character Count Is Incorrect!")
        // Account for the four extra characters of the appended " ..." string
        XCTAssertTrue(truncatedLongSentence.count == 24, "Character Count Is Incorrect!")
        XCTAssertTrue(truncatedNoSentence.count < 1, "Character Count Is Incorrect!")
        let expectedTruncatedLongSentence = "This is a sentence l ..."
        XCTAssertEqual(truncatedLongSentence, expectedTruncatedLongSentence, "String Failed To Truncate")
    }
    
    func testRandomStateString() {
        let randomString = String.randomStateString(20)
        XCTAssertNotNil(randomString, "Value Should Not Be Nil!")
        XCTAssertTrue(randomString.count == 20, "Length Should Be 20!")
    }
}
