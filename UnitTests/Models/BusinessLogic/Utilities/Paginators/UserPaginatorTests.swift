//
//  UserPaginatorTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class UserPaginatorTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testFetchUsers() {
        let userPaginator = UserPaginator()
        var users = [User]()
        let fetchUsersTestOneExpectation = expectation(description: "Test Fetch Users One")
        let fetchUsersTestTwoExpectation = expectation(description: "Test Fetch Users Two")
        // Test getting first page of results
        userPaginator.fetchNextPage(shouldClean: true, success: { (fetchedUsers: [User]) in
            users.append(contentsOf: fetchedUsers)
            XCTAssertTrue(users.count == 30, "Incorrect Count Of Users!")
            // Test getting second page of results
            userPaginator.fetchNextPage(shouldClean: false, success: { (fetchedUsers2: [User]) in
                users.append(contentsOf: fetchedUsers2)
                XCTAssertTrue(users.count == 60, "Incorrect Count Of Users!")
                fetchUsersTestTwoExpectation.fulfill()
            }, failure: { _ in
                XCTFail("Error Getting Second List Of Users")
                fetchUsersTestTwoExpectation.fulfill()
            })
            fetchUsersTestOneExpectation.fulfill()
        }) { _ in
            XCTFail("Error Getting First List Of Users")
            fetchUsersTestOneExpectation.fulfill()
            fetchUsersTestTwoExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
