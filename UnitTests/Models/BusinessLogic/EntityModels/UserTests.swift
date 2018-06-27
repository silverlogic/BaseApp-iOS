//
//  UserTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
@testable import Development
import XCTest

final class UserTests: BaseUnitTests {
    
    // MARK: - Functionality Tests
    func testAvatarUrl() {
        guard let user = User.mockInstance() else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 50
        // swiftlint:disable line_length
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Apple_Computer_Logo_rainbow.svg/931px-Apple_Computer_Logo_rainbow.svg.png")!
        // swiftlint:enable line_length
        user.avatarUrl = url
        XCTAssertEqual(user.avatarUrl, url, "Formatting Not Correct!")
    }
    
    func testFullName() {
        guard let user = User.mockInstance() else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 52
        user.firstName = "Bob"
        user.lastName = "Saget"
        let fullName = user.fullName
        XCTAssertEqual(fullName, "Bob Saget", "Formatting Not Correct!")
        guard let user2 = User.mockInstance() else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user2.userId = 53
        user2.firstName = nil
        user2.lastName = nil
        let fullName2 = user2.fullName
        XCTAssertEqual(fullName2, "Unidentified Name", "Formatting Not Correct!")
        guard let user3 = User.mockInstance() else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user3.userId = 54
        user3.firstName = ""
        user3.lastName = ""
        let fullName3 = user3.fullName
        XCTAssertEqual(fullName3, "Unidentified Name", "Formatting Not Correct!")
    }
}
