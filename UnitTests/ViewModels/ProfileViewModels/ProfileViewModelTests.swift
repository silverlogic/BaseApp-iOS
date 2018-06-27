//
//  ProfileViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class ProfileViewModelTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testUpdateProfile() {
        guard let user = User.mockInstance() else {
            XCTFail("Error Creating Test User Model!")
            return
        }
        SessionManager.shared.currentUser = MultiDynamicBinder(user)
        SessionManager.shared.currentUser.value?.userId = 210
        let updateProfileErrorExpectation = expectation(description: "Test Update Profile Error")
        let updateProfileSuccessExpectation = expectation(description: "Tests Update Profile")
        let profileViewModel = ViewModelsManager.profileViewModel(user: SessionManager.shared.currentUser)
        profileViewModel.updateProfileError.bind { _ in
            profileViewModel.firstName = "Bob"
            profileViewModel.lastName = "Saget"
            profileViewModel.updateProfile()
            updateProfileErrorExpectation.fulfill()
        }
        profileViewModel.updateProfileSuccess.bind { _ in
            updateProfileSuccessExpectation.fulfill()
        }
        profileViewModel.updateProfile()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
