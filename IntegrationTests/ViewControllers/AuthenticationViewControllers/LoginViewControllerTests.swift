//
//  LoginViewControllerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/25/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

final class LoginViewControllerTests: BaseIntegrationTests {
    
    // MARK: - Functional Tests
    func testEmptyFields() {
        tester().tapView(withAccessibilityLabel: "loginButton")
        tester().waitForView(withAccessibilityLabel: "emailTextField")
        tester().waitForView(withAccessibilityLabel: "passwordTextField")
    }
    
    func testSuccessfulLogin() {
        tester().enterText("testuser@tsl.io", intoViewWithAccessibilityLabel: "emailTextField")
        tester().enterText("testuser@tsl.io", intoViewWithAccessibilityLabel: "passwordTextField")
        tester().tapView(withAccessibilityLabel: "loginButton")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "emailTextField")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "passwordTextField")
        tester().waitForAbsenceOfView(withAccessibilityLabel: "loginButton")
    }
}
