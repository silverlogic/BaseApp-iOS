//
//  AuthenticationManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class AuthenticationManagerTests: BaseUnitTests {
    
    // MARK: - Attributes
    fileprivate var sharedManager: AuthenticationManager!
    
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        sharedManager = AuthenticationManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        sharedManager = nil
    }
}


// MARK: - Functional Tests
extension AuthenticationManagerTests {
    func testLogin() {
        let loginExpectation = expectation(description: "Test Login")
        sharedManager.login(email: "testuser@tsl.io", password: "1234", success: {
            XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
            XCTAssertEqual(SessionManager.shared.currentUser.value?.userId, 210, "Wrong User Loaded!")
            loginExpectation.fulfill()
        }) { _ in
            XCTFail("Error Logging In!")
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSignup() {
        let signupInfo = SignUpInfo(email: "testuser@tsl.io", password: "1234", referralCodeOfReferrer: nil)
        let updateIndo = UpdateInfo(referralCodeOfReferrer: nil,
                                    avatarBaseString: nil,
                                    firstName: "Bob",
                                    lastName: "Saget")
        let signupExpectation = expectation(description: "Test Signup")
        sharedManager.signup(signupInfo, updateInfo: updateIndo, success: {
            XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
            XCTAssertEqual(SessionManager.shared.currentUser.value?.userId,
                           210,
                           "Signing Up User Failed!")
            XCTAssertEqual(SessionManager.shared.currentUser.value?.email,
                           "testuser@tsl.io",
                           "Signing Up User Failed!")
            XCTAssertEqual(SessionManager.shared.currentUser.value?.firstName,
                           "Bob",
                           "Signing Up User Failed!")
            XCTAssertEqual(SessionManager.shared.currentUser.value?.lastName,
                           "Saget",
                           "Signing Up User Failed!")
            signupExpectation.fulfill()
        }) { _ in
            XCTFail("Error Signing Up!")
            signupExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCurrentUser() {
        let currentUserExpectation = expectation(description: "Test Current User")
        sharedManager.currentUser(success: { 
            currentUserExpectation.fulfill()
        }) { _ in
            XCTFail("Error Getting Current User!")
            currentUserExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginWithOAuth2() {
        // swiftlint:disable line_length
        let redirectUrlWithQueryParametersFacebook = URL(string: "https://app.baseapp.tsl.io/?code=AQAf7IEllTmPlGXimVmK4A7ksXxRLU75FoiXO7lmc7sncGGvHG-o2_73Y5S2FrhPQvKicHm3kByu--Ou0hk2eRp9jFwArTrkbpXn2CljaG3BFWwNC6aSnruJmt-dHv1_9u-54xRYTSelP89WOqWGewEPWD5Sw1TgPiOXTHPebz3eiH43PTwm0KQhp2AFWSl7Q2zbkF0186yInZVL7JS4ms9phm8k7FF5OiEGBPMUFHMDzpCGewGmTAU5XJwGtZBiEitpftI6UmblIQQ0GuACm0S8qRTM_F5Xg2RBHFhZdw4-EgQ3qlQSxqfcwKZ9OxH4PP0#_=_")!
        let redirectUrlWithQuertParametersLinkedIn = URL(string: "https://app.baseapp.tsl.io/?code=AQREi3AZUQ0FEruGOrZwk8mtuaw7EnAr6S0XiAlMQT3lXi4J8pt7xD5ebEUye8PQwQY0FbdFK5NeFOmHyrW4w72SrNyCWQOujYtqXjx1G1IIDzjI4Ak&state=Av4WcUi9bZqFr1Ajk9GBBeLcVawFwqdi5MQaRtzTTitBta9WBMCJE2Qv1IwnNS")!
        // swiftline:enable line_length
        let redirectUrl = "https://app.baseapp.tsl.io/"
        let loginWithFacebookExpectation = expectation(description: "Test OAuth Login For Facebook")
        let loginWithLinkedInExpectation = expectation(description: "Test OAuth Login For LinkedIn")
        let operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 1
        operationQueue.addOperation {
            operationQueue.isSuspended = true
            self.sharedManager.loginWithOAuth2(redirectUrlWithQueryParameters: redirectUrlWithQueryParametersFacebook,
                                               redirectUri: redirectUrl,
                                               provider: .facebook,
                                               email: nil,
                                               success: {
                XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
                loginWithFacebookExpectation.fulfill()
                operationQueue.isSuspended = false
            }) { _ in
                XCTFail("Error Logging In With OAuth2!")
                loginWithFacebookExpectation.fulfill()
                operationQueue.isSuspended = false
            }
        }
        operationQueue.addOperation {
            operationQueue.isSuspended = true
            self.sharedManager.loginWithOAuth2(redirectUrlWithQueryParameters: redirectUrlWithQuertParametersLinkedIn,
                                               redirectUri: redirectUrl,
                                               provider: .linkedIn,
                                               email: nil,
                                               success: {
                XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
                loginWithLinkedInExpectation.fulfill()
                operationQueue.isSuspended = false
            }, failure: { _ in
                XCTFail("Error Logging In With OAuth2!")
                loginWithLinkedInExpectation.fulfill()
                operationQueue.isSuspended = false
            })
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testOauth1Step1() {
        let redirectUrl = "https://app.baseapp.tsl.io/"
        let oauth1StepOneExpectation = expectation(description: "Test OAuth1 Step One")
        sharedManager.oauth1Step1(redirectUri: redirectUrl, provider: .twitter, success: { (response: OAuth1Step1Response) in
            XCTAssertNotNil(response, "Value Should Not Be Nil!")
            XCTAssertEqual(response.oauthTokenSecret, "cYwcHxWW7OSnqY5W3FTZPvCJQNPfPX4N", "Error Getting OAuth1 Info!")
            XCTAssertEqual(response.oauthCallBackConfirmed, "true", "Error Getting OAuth1 Info!")
            XCTAssertEqual(response.oauthToken, "0MxsWgAAAAAAwS-_AAABVld_DHo", "Error Getting OAuth1 Info!")
            oauth1StepOneExpectation.fulfill()
        }) { _ in
            XCTFail("Error Getting Info For OAuth1!")
            oauth1StepOneExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginWithOAuth1() {
        let redirectUrlWithQueryParametersTwitter = URL(string: "https://app.baseapp.tsl.io/?redirect_state=hpZksuzwUGU04qHo4LjQJdoXCtt6mupP&oauth_token=BJgZrwAAAAAAwS-_AAABWwwTJVQ&oauth_verifier=qeXqTX5DrLTYstNiIKF62NHRUZwnepEu")!
        var oauth1Response = OAuth1Step1Response()
        oauth1Response.oauthToken = "BJgZrwAAAAAAwS-_AAABWwwTJVQ"
        oauth1Response.oauthTokenSecret = "hREBrTNPesd2HCvRD8V9eyFS3s8MK8G9"
        oauth1Response.oauthCallBackConfirmed = "true"
        let loginWithTwitterExpectation = expectation(description: "Test Login With Twitter")
        sharedManager.loginWithOAuth1(redirectUrlWithQueryParameters: redirectUrlWithQueryParametersTwitter, provider: .twitter, oauth1Response: oauth1Response, email: nil, success: { 
            XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
            loginWithTwitterExpectation.fulfill()
        }) { _ in
            XCTFail("Error Logging With Twitter!")
            loginWithTwitterExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testForgotPasswordRequest() {
        let forgotPasswordRequestExpectation = expectation(description: "Test Forgot Password Expectation")
        sharedManager.forgotPasswordRequest(email: "testuser@tsl.io", success: { 
            forgotPasswordRequestExpectation.fulfill()
        }) { _ in
            XCTFail("Error Sending Forgot Password Request!")
            forgotPasswordRequestExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testForgotPasswordReset() {
        let forgotPasswordRestExpectation = expectation(description: "Test Forgot Password Reset Expectation")
        sharedManager.forgotPasswordReset(token: "AAAGGYY3254fdfdqwee434e3rfdfd", newPassword: "1235", success: { 
            forgotPasswordRestExpectation.fulfill()
        }) { _ in
            XCTFail("Error Sending Forgot Password Reset!")
            forgotPasswordRestExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChangeEmailRequest() {
        let changeEmailRequestExpectation = expectation(description: "Test Change Email Request Expectation")
        sharedManager.changeEmailRequest(newEmail: "testuser@tsl.io", success: { 
            changeEmailRequestExpectation.fulfill()
        }) { _ in
            XCTFail("Error Doing Change Email Request!")
            changeEmailRequestExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChangeEmailConfirm() {
        let changeEmailConfirmExpectation = expectation(description: "Test Change Email Confirm Expectation")
        sharedManager.changeEmailConfirm(token: "HG@#@BKJBHbJ@Bhuihuhgig23223243", userId: 1, success: { 
            changeEmailConfirmExpectation.fulfill()
        }) { _ in
            XCTFail("Error Doing Change Email Confirm!")
            changeEmailConfirmExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChangeEmailVerify() {
        let changeEmailVerifyExpectation = expectation(description: "Test Change Email Verify Expectation")
        sharedManager.changeEmailVerify(token: "HG@#@BKJBHbJ@Bhuihuhgig23223243", userId: 1, success: { 
            changeEmailVerifyExpectation.fulfill()
        }) { _ in
            XCTFail("Error Doing Change Email Verify!")
            changeEmailVerifyExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testChangePassword() {
        let changePasswordExpectation = expectation(description: "Test Change Password Expectation")
        sharedManager.changePassword(currentPassword: "1234", newPassword: "1235", success: { 
            changePasswordExpectation.fulfill()
        }) { _ in
            XCTFail("Error Doing Change Password!")
            changePasswordExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testConfirmEmail() {
        let confirmEmailExpectation = expectation(description: "Test Confirm Email Expectation")
        sharedManager.confirmEmail(token: "HG@#@BKJBHbJ@Bhuihuhgig23223243", userId: 1, success: { 
            confirmEmailExpectation.fulfill()
        }) { _ in
            XCTFail("Error Doing Confirm Email!")
            confirmEmailExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
