//
//  SessionManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
@testable import Development
import XCTest

final class SessionManagerTests: BaseUnitTests {
    
    // MARK: - Private Instance Attributes
    fileprivate var sharedManager: SessionManager!
    
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        sharedManager = SessionManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        sharedManager = nil
    }
}


// MARK: - Functional Tests
extension SessionManagerTests {
    func testUpdate() {
        guard let user = User.mockInstance() else {
            XCTFail("Error Creating Test User Model!")
            return
        }
        sharedManager.currentUser = MultiDynamicBinder(user)
        sharedManager.currentUser.value?.userId = 210
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil,
                                    avatarBaseString: nil,
                                    firstName: "Bob",
                                    lastName: "Saget")
        let updateUserExpectation = expectation(description: "Test Updating User")
        sharedManager.update(updateInfo, success: {
            XCTAssertEqual(self.sharedManager.currentUser.value?.firstName, "Bob", "Updating User Failed!")
            XCTAssertEqual(self.sharedManager.currentUser.value?.lastName, "Saget", "Updating User Failed!")
            updateUserExpectation.fulfill()
        }) { _ in
            XCTFail("Error Updating User!")
            updateUserExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLogout() {
        guard let user = User.mockInstance() else {
            XCTFail("Error Creating Test User Model!")
            return
        }
        sharedManager.currentUser = MultiDynamicBinder(user)
        sharedManager.currentUser.value?.userId = 211
        let logoutExpectation = expectation(description: "Test Logout")
        sharedManager.logout()
        sharedManager.currentUser.interface.bind({ [weak self] (user: User?) in
            guard let strongSelf = self else {
                logoutExpectation.fulfill()
                return
            }
            XCTAssertNil(user, "Value Should Be Nil!")
            strongSelf.sharedManager.currentUser.interface.unbind(for: strongSelf)
            logoutExpectation.fulfill()
        }, for: self)
        waitForExpectations(timeout: 10, handler: nil)
    }
}
