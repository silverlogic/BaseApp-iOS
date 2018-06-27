//
//  KeychainManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/19/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class KeychainManagerTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testKeychainForStrings() {
        let testString = "Bob Saget"
        KeychainManager.shared.insertItem(testString, for: "Danny Tanner")
        guard let storedString = KeychainManager.shared.stringForKey("Danny Tanner") else {
            XCTFail("String Not Stored In Keychain!")
            return
        }
        XCTAssertEqual(testString, storedString, "These Aren't The Same!")
        KeychainManager.shared.removeItemForKey("Danny Tanner")
        let emptyValue = KeychainManager.shared.stringForKey("Danny Tanner")
        XCTAssertNil(emptyValue, "String Was Never Removed From Keychain!")
    }
    
    func testKeychainForData() {
        let testData = Data()
        KeychainManager.shared.insertItem(testData, for: "My Data")
        guard let storedData = KeychainManager.shared.dataForKey("My Data") else {
            XCTFail("Data Not Stored In Keychain!")
            return
        }
        XCTAssertEqual(testData, storedData, "These Aren't The Same!")
        KeychainManager.shared.removeItemForKey("My Data")
        let emptyValue = KeychainManager.shared.dataForKey("My Data")
        XCTAssertNil(emptyValue, "Data Was Never Removed From Keychain!")
    }
}
