//
//  SettingViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class SettingViewModelTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testLogout() {
        let settingViewModel = ViewModelsManager.settingViewModel()
        settingViewModel.logout()
    }
    
    func testChangeEmailRequest() {
        let settingViewModel = ViewModelsManager.settingViewModel()
        let changeEmailRequestErrorExpectation = expectation(description: "Test Change Email Request Error")
        // swiftlint:disable line_length
        let changeEmailRequestSuccessExpectation = expectation(description: "Test Change Email Request Success")
        // swiftlint:enable line_length
        settingViewModel.changeEmailRequestError.bind { _ in
            settingViewModel.changeEmailRequest(newEmail: "testuser@tsl.io")
            changeEmailRequestErrorExpectation.fulfill()
        }
        settingViewModel.changeEmailRequestSuccess.bind { _ in
            changeEmailRequestSuccessExpectation.fulfill()
        }
        settingViewModel.changeEmailRequest(newEmail: "")
        waitForExpectations(timeout: 10, handler: nil)
    }
}
