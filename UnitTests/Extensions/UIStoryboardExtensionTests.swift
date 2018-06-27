//
//  UIStoryboardExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class UIStoryboardExtensionTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testLoadInitializeViewController() {
        let baseTabBarController = UIStoryboard.loadInitialViewController()
        XCTAssertNotNil(baseTabBarController, "Value Should Not Be Nil!")
    }
    
    func testLoadLoginViewController() {
        let loginViewController = UIStoryboard.loadLoginViewController()
        XCTAssertNotNil(loginViewController, "Value Should Not Be Nil!")
    }
    
    func testLoadForgotPasswordResetViewController() {
        let forgotPasswordViewController = UIStoryboard.loadForgotPasswordResetViewController()
        XCTAssertNotNil(forgotPasswordViewController, "Value Should Not Be Nil!")
    }
    
    func testLoadChangeEmailVerifyViewController() {
        let changeEmailVerifyViewController = UIStoryboard.loadChangeEmailVerifyViewController
        XCTAssertNotNil(changeEmailVerifyViewController, "Value Should Not Be Nil!")
    }
}
