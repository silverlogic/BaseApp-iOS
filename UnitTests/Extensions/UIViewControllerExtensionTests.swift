//
//  UIViewControllerExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class UIViewControllerExtensionTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testStoryboardIdentifier() {
        XCTAssertEqual(LoginViewController.storyboardIdentifier, "LoginViewController", "Incorrect Format!")
        XCTAssertEqual(UITabBarController.storyboardIdentifier, "UITabBarController", "Incorrect Format!")
    }
}
