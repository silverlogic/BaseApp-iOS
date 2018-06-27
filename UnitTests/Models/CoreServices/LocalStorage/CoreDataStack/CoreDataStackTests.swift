//
//  CoreDataStackTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
@testable import Development
import XCTest

final class CoreDataStackTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testFetchObjects() {
        guard let user = User.mockInstance() else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 1
        let fetchExpectation = expectation(description: "Test Fetching Objects")
        CoreDataStack.shared.fetchObjects(fetchRequest: User.specificUserFetchRequest(userId: 1),
                                          success: { (users: [User]) in
            XCTAssertTrue(users.count == 1, "Incorrect amount of objects retrieved!")
            guard let fetchedUser = users.first else {
                XCTFail("Error Getting Fetched User!")
                fetchExpectation.fulfill()
                return
            }
            XCTAssertEqual(user.userId, fetchedUser.userId, "Incorrect user fetched!")
            fetchExpectation.fulfill()
        }) { 
            XCTFail("Error Fetching User")
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDeleteObject() {
        guard let user = User.mockInstance() else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 2
        let deletetionExpectation = expectation(description: "Test Deleting Object")
        let fetchExpectation = expectation(description: "Test Fetching Objects")
        CoreDataStack.shared.deleteObject(user, success: {
            CoreDataStack.shared.fetchObjects(fetchRequest: User.specificUserFetchRequest(userId: 2),
                                              success: { (users: [User]) in
                XCTAssertTrue(users.isEmpty, "Incorrect amount of objects retrieved!")
                fetchExpectation.fulfill()
            }, failure: { 
                XCTFail("Error Fetching User")
                fetchExpectation.fulfill()
            })
            deletetionExpectation.fulfill()
        }) {
            XCTFail("Error Deleting Object!")
            deletetionExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testInsertObject() {
        let insertExpectation = expectation(description: "Test Inserting Object")
        let fetchExpectation = expectation(description: "Test Fetching Inserted Object")
        let updateExpectation = expectation(description: "Test Updating Object")
        CoreDataStack.shared.insertObject(for: User.self, success: { (user: User) in
            user.userId = 3
            CoreDataStack.shared.saveCurrentState(success: {
                CoreDataStack.shared.fetchObjects(fetchRequest: User.specificUserFetchRequest(userId: 3),
                                                  success: { (users: [User]) in
                    XCTAssertTrue(users.count == 1, "Object Never Inserted!")
                    guard let user2 = users.first else {
                        XCTFail("Error Getting Object From Array!")
                        fetchExpectation.fulfill()
                        return
                    }
                    XCTAssertEqual(user.userId, user2.userId, "These Should Be The Same!")
                    fetchExpectation.fulfill()
                }, failure: { 
                    XCTFail("Error Fetching Object!")
                    fetchExpectation.fulfill()
                })
                updateExpectation.fulfill()
            }, failure: { 
                XCTFail("Error Updating Object!")
                fetchExpectation.fulfill()
                updateExpectation.fulfill()
            })
            insertExpectation.fulfill()
        }) { 
            XCTFail("Error Inserting Object!")
            insertExpectation.fulfill()
            fetchExpectation.fulfill()
            updateExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
