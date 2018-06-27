//
//  AuthenticationEndpointTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
@testable import Development
import XCTest

// swiftlint:disable line_length type_body_length

final class AuthenticationEndpointTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testLoginEndpoint() {
        let loginEndpoint = AuthenticationEndpoint.login(email: "testuser@tsl.io", password: "1234")
        XCTAssertNotNil(loginEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(loginEndpoint.endpointInfo.path, "login", "Path Not Correct!")
        XCTAssertEqual(loginEndpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(loginEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(loginEndpoint.endpointInfo.parameterEncoding is JSONEncoding, "Encoding Not Correct!")
        XCTAssertFalse(loginEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
    
    func testSignUpEndpoint() {
        let signupInfo = SignUpInfo(email: "testuser@tsl.io", password: "1234", referralCodeOfReferrer: nil)
        let signupEndpoint = AuthenticationEndpoint.signUp(signUpInfo: signupInfo)
        XCTAssertNotNil(signupEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(signupEndpoint.endpointInfo.path, "register", "Path Not Correct!")
        XCTAssertEqual(signupEndpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(signupEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(signupEndpoint.endpointInfo.parameterEncoding is JSONEncoding, "Encoding Not Correct!")
        XCTAssertFalse(signupEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
    
    func testUpdateEndpoint() {
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil,
                                    avatarBaseString: nil,
                                    firstName: "Bob",
                                    lastName: "Saget")
        let updateEndpoint = AuthenticationEndpoint.update(updateInfo: updateInfo, userId: 1)
        XCTAssertNotNil(updateEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(updateEndpoint.endpointInfo.path, "users/1", "Path Not Correct")
        XCTAssertEqual(updateEndpoint.endpointInfo.requestMethod, .patch, "Request Method Not Correct!")
        XCTAssertNotNil(updateEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(updateEndpoint.endpointInfo.parameterEncoding is JSONEncoding, "Encoding Not Correct!")
        XCTAssertTrue(updateEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True")
    }
    
    func testCurrentUserEndpoint() {
        let currentUserEndpoint = AuthenticationEndpoint.currentUser
        XCTAssertNotNil(currentUserEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(currentUserEndpoint.endpointInfo.path, "users/me", "Path Not Correct!")
        XCTAssertEqual(currentUserEndpoint.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNil(currentUserEndpoint.endpointInfo.parameters, "Value Should Be Nil")
        XCTAssertTrue(currentUserEndpoint.endpointInfo.parameterEncoding is URLEncoding,
                      "Encoding Not Correct!")
        XCTAssertTrue(currentUserEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True")
    }
    
    func testOAuth2Endpoint() {
        let oauth2Info = OAuth2Info(provider: .facebook,
                                    oauthCode: "AQAf7IEllTmPlGXimVmK4A7ksXxRLU75FoiXO7lmc7sncGGvHG-o2_73Y5S2FrhPQvKicHm3kByu--Ou0hk2eRp9jFwArTrkbpXn2CljaG3BFWwNC6aSnruJmt-dHv1_9u-54xRYTSelP89WOqWGewEPWD5Sw1TgPiOXTHPebz3eiH43PTwm0KQhp2AFWSl7Q2zbkF0186yInZVL7JS4ms9phm8k7FF5OiEGBPMUFHMDzpCGewGmTAU5XJwGtZBiEitpftI6UmblIQQ0GuACm0S8qRTM_F5Xg2RBHFhZdw4-EgQ3qlQSxqfcwKZ9OxH4PP0#_=_",
                                    redirectUri: "https://app.baseapp.tsl.io/",
                                    email: nil,
                                    referralCodeOfReferrer: nil)
        let oauth2Endpoint = AuthenticationEndpoint.oauth2(oauth2Info: oauth2Info)
        XCTAssertNotNil(oauth2Endpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(oauth2Endpoint.endpointInfo.path, "social-auth", "Path Not Correct")
        XCTAssertEqual(oauth2Endpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(oauth2Endpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(oauth2Endpoint.endpointInfo.parameterEncoding is JSONEncoding, "Encoding Not Correct!")
        XCTAssertFalse(oauth2Endpoint.endpointInfo.requiresAuthorization, "Value Should Be False")
    }
    
    func testOAuth1Step1Endpoint() {
        let oauth1Step1Info = OAuth1Step1Info(provider: .twitter, redirectUri: "https://app.baseapp.tsl.io/")
        let oauth1Step1Endpoint = AuthenticationEndpoint.oauth1Step1(oauth1Step1Info: oauth1Step1Info)
        XCTAssertNotNil(oauth1Step1Endpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(oauth1Step1Endpoint.endpointInfo.path, "social-auth", "Path Not Correct!")
        XCTAssertEqual(oauth1Step1Endpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(oauth1Step1Endpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(oauth1Step1Endpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(oauth1Step1Endpoint.endpointInfo.requiresAuthorization, "Value Should Be False")
    }
    
    func testOAuth1Step2Endpoint() {
        let oauth1Step2Info = OAuth1Step2Info(provider: .twitter,
                                              oauthToken: "AQAf7IEllTmPlGXimVmK4A7ksXxRLU75FoiXO7lmc7sncGGvHG-o2_73Y5S2FrhPQvKicHm3kByu--Ou0hk2eRp9jFwArTrkbpXn2CljaG3BFWwNC6aSnruJmt-dHv1_9u-54xRYTSelP89WOqWGewEPWD5Sw1TgPiOXTHPebz3eiH43PTwm0KQhp2AFWSl7Q2zbkF0186yInZVL7JS4ms9phm8k7FF5OiEGBPMUFHMDzpCGewGmTAU5XJwGtZBiEitpftI6UmblIQQ0GuACm0S8qRTM_F5Xg2RBHFhZdw4-EgQ3qlQSxqfcwKZ9OxH4PP0#_=_",
                                              oauthTokenSecret: "hREBrTNPesd2HCvRD8V9eyFS3s8MK8G9",
                                              oauthVerifier: "BJgZrwAAAAAAwS-_AAABWwwTJVQ",
                                              email: nil,
                                              referralCodeOfReferrer: nil)
        let oauth1Step2Endpoint = AuthenticationEndpoint.oauth1Step2(oauth1Step2Info: oauth1Step2Info)
        XCTAssertNotNil(oauth1Step2Endpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(oauth1Step2Endpoint.endpointInfo.path, "social-auth", "Path Not Correct!")
        XCTAssertEqual(oauth1Step2Endpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(oauth1Step2Endpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(oauth1Step2Endpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(oauth1Step2Endpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
    
    func testForgotPasswordRequestEndpoint() {
        let forgotPasswordRequestEndpoint = AuthenticationEndpoint.forgotPasswordRequest(email: "testuser@tsl.io")
        XCTAssertNotNil(forgotPasswordRequestEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(forgotPasswordRequestEndpoint.endpointInfo.path,
                       "forgot-password",
                       "Path Not Correct!")
        XCTAssertEqual(forgotPasswordRequestEndpoint.endpointInfo.requestMethod,
                       .post,
                       "Request Method Not Correct!")
        XCTAssertNotNil(forgotPasswordRequestEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(forgotPasswordRequestEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(forgotPasswordRequestEndpoint.endpointInfo.requiresAuthorization,
                       "Value Should Be False!")
    }
    
    func testForgotPasswordResetEndpoint() {
        let forgotPasswordResetEndpoint = AuthenticationEndpoint.forgotPasswordReset(token: "bjdhdhehru3r3iu4gyf", newPassword: "1235")
        XCTAssertNotNil(forgotPasswordResetEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(forgotPasswordResetEndpoint.endpointInfo.path,
                       "forgot-password/reset",
                       "Path Not Correct!")
        XCTAssertEqual(forgotPasswordResetEndpoint.endpointInfo.requestMethod,
                       .post,
                       "Request Method Not Correct!")
        XCTAssertNotNil(forgotPasswordResetEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(forgotPasswordResetEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(forgotPasswordResetEndpoint.endpointInfo.requiresAuthorization,
                       "Value Should Be False!")
    }
    
    func testChangeEmailRequestEndpoint() {
        let changeEmailRequestEndpoint = AuthenticationEndpoint.changeEmailRequest(newEmail: "testuser@tsl.io")
        XCTAssertNotNil(changeEmailRequestEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(changeEmailRequestEndpoint.endpointInfo.path, "change-email", "Path Not Correct!")
        XCTAssertEqual(changeEmailRequestEndpoint.endpointInfo.requestMethod,
                       .post,
                       "Request Method Not Correct!")
        XCTAssertNotNil(changeEmailRequestEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(changeEmailRequestEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertTrue(changeEmailRequestEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }
    
    func testChangeEmailConfirmEndpoint() {
        let changeEmailConfirmEndpoint = AuthenticationEndpoint.changeEmailConfirm(token: "fjfheahduianSAZUJNFJFRITHUGRUEHGNJTNGOIETU849R574WHGNRJOGNAH789Yy9ushforwuht98374qty", userId: 1)
        XCTAssertNotNil(changeEmailConfirmEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(changeEmailConfirmEndpoint.endpointInfo.path,
                       "change-email/1/confirm",
                       "Path Not Correct!")
        XCTAssertEqual(changeEmailConfirmEndpoint.endpointInfo.requestMethod,
                       .post,
                       "Request Method Not Correct!")
        XCTAssertNotNil(changeEmailConfirmEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(changeEmailConfirmEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(changeEmailConfirmEndpoint.endpointInfo.requiresAuthorization,
                       "Value Should Be False!")
    }
    
    func testChangeEmailVerifyEndpoint() {
        let changeEmailVerifyEndpoint = AuthenticationEndpoint.changeEmailVerify(token: "fjfheahduianSAZUJNFJFRITHUGRUEHGNJTNGOIETU849R574WHGNRJOGNAH789Yy9ushforwuht98374qty", userId: 1)
        XCTAssertNotNil(changeEmailVerifyEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(changeEmailVerifyEndpoint.endpointInfo.path,
                       "change-email/1/verify",
                       "Path Not Correct!")
        XCTAssertEqual(changeEmailVerifyEndpoint.endpointInfo.requestMethod,
                       .post,
                       "Request Method Not Correct!")
        XCTAssertNotNil(changeEmailVerifyEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(changeEmailVerifyEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(changeEmailVerifyEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
    
    func testChangePasswordEndpoint() {
        let changePasswordEndpoint = AuthenticationEndpoint.changePassword(currentPassword: "1234",
                                                                           newPassword: "1235")
        XCTAssertNotNil(changePasswordEndpoint, "Valie Should Not Be Nil!")
        XCTAssertEqual(changePasswordEndpoint.endpointInfo.path, "users/change-password", "Path Not Correct!")
        XCTAssertEqual(changePasswordEndpoint.endpointInfo.requestMethod,
                       .post,
                       "Request Method Not Correct!")
        XCTAssertNotNil(changePasswordEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(changePasswordEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertTrue(changePasswordEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }
    
    func testConfirmEmailEndpoint() {
        let confirmEmailEndpoint = AuthenticationEndpoint.confirmEmail(token: "fjfheahduianSAZUJNFJFRITHUGRUEHGNJTNGOIETU849R574WHGNRJOGNAH789Yy9ushforwuht98374qty", userId: 1)
        XCTAssertNotNil(confirmEmailEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(confirmEmailEndpoint.endpointInfo.path, "users/1/confirm-email", "Path Not Correct!")
        XCTAssertEqual(confirmEmailEndpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(confirmEmailEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(confirmEmailEndpoint.endpointInfo.parameterEncoding is JSONEncoding,
                      "Encoding Not Correct!")
        XCTAssertFalse(confirmEmailEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
}

// swiftlint:enable line_length type_body_length
