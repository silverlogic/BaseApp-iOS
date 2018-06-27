//
//  BaseAppV2UITests.swift
//  BaseAppV2UITests
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest

class BaseUITests: XCTestCase {
    
    // MARK: - Fastlane Snapshot
    func testFastlaneSnapshot() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        let emailtextfieldTextField = app.textFields["emailTextField"]
        emailtextfieldTextField.tap()
        emailtextfieldTextField.typeText("eg@tsl.io")
        app.buttons["Next:"].tap()
        let passwordtextfieldSecureTextField = app.secureTextFields["passwordTextField"]
        let moreNumbersKey = app.keys["more, numbers"]
        moreNumbersKey.tap()
        passwordtextfieldSecureTextField.typeText("1235")
        snapshot("Login")
        app.buttons["Go"].tap()
        
        app.tables["Empty list"].tap()
        snapshot("UserFeed")
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Profile"].tap()
        snapshot("Profile")
        tabBarsQuery.buttons["Settings"].tap()
        snapshot("Settings")
        app.tables.staticTexts["Logout"].tap()
    }
}
