//
//  ForgotPasswordViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class ForgotPasswordViewModelTests: BaseUnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: nil)
        XCTAssertNotNil(forgotPasswordViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(forgotPasswordViewModel.email, "", "Initialization Failed!")
        XCTAssertEqual(forgotPasswordViewModel.newPassword, "", "Initialization Failed!")
        XCTAssertNil(forgotPasswordViewModel.forgotPasswordError.value, "Initialization Failed!")
        XCTAssertFalse(forgotPasswordViewModel.forgotPasswordRequestSuccess.value, "Initialization Failed!")
        XCTAssertFalse(forgotPasswordViewModel.forgotPasswordResetSuccess.value, "Initialization Failed!")
    }
    
    
    // MARK: - Functional Tests
    func testForgotPasswordRequest() {
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: nil)
        let forgotPasswordRequestExpectation = expectation(description: "Test Forgot Password Expectation")
        // swiftlint:disable line_length
        let forgotPasswordRequestErrorExpectation = expectation(description: "Test Forgot Password Error Expectation")
        // swiftlint:enable line_length
        forgotPasswordViewModel.forgotPasswordError.bind { _ in
            forgotPasswordViewModel.email = "testuser@tsl.io"
            forgotPasswordViewModel.forgotPasswordRequest()
            forgotPasswordRequestErrorExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordRequestSuccess.bind { _ in
            forgotPasswordRequestExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordRequest()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testForgotPasswordReset() {
        let forgotPasswordViewModel = ViewModelsManager
                                      .forgotPasswordViewModel(token: "AAADCC32jjsxndiehroens38er8f8wyq3rg32")
        let forgotPasswordResetExpectation = expectation(description: "Test Forgot Password Expectation")
        // swiftlint:disable line_length
        let forgotPasswordResetErrorExpectation = expectation(description: "Test Forgot Password Error Expectation")
        // swiftlint:enable line_length
        forgotPasswordViewModel.forgotPasswordError.bind { _ in
            forgotPasswordViewModel.newPassword = "1235"
            forgotPasswordViewModel.forgotPasswordReset()
            forgotPasswordResetErrorExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordResetSuccess.bind { _ in
            forgotPasswordResetExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordReset()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCancelResetPassword() {
        let forgotPasswordViewModel = ViewModelsManager
                                      .forgotPasswordViewModel(token: "AAADCC32jjsxndiehroens38er8f8wyq3rg32")
        forgotPasswordViewModel.cancelResetPassword()
    }
}
