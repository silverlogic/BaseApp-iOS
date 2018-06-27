//
//  ChangeEmailVerifyViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class ChangeEmailVerifyViewModelTests: BaseUnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let changeEmailVerifyViewModel = ViewModelsManager.changeEmailVerifyViewModel(token: "hjdsahcaHjHU",
                                                                                      userId: 1)
        XCTAssertNotNil(changeEmailVerifyViewModel, "Value Should Not Be Nil!")
        XCTAssertNil(changeEmailVerifyViewModel.changeEmailVerifyError.value, "Value Should Be Nil!")
        XCTAssertFalse(changeEmailVerifyViewModel.changeEmailVerifySuccess.value, "Value Should Be False!")
    }
    
    func testChangeEmailVerify() {
        let changeEmailVerifyViewModel = ViewModelsManager.changeEmailVerifyViewModel(token: "hjdsahcaHjHUY8",
                                                                                      userId: 1)
        let changeEmailVerifyExpectation = expectation(description: "Test Change Email Verify")
        changeEmailVerifyViewModel.changeEmailVerifyError.bind { _ in
            XCTFail("Error Doing Change Email Verify!")
            changeEmailVerifyExpectation.fulfill()
        }
        changeEmailVerifyViewModel.changeEmailVerifySuccess.bind { _ in
            changeEmailVerifyExpectation.fulfill()
        }
        changeEmailVerifyViewModel.changeEmailVerify()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
