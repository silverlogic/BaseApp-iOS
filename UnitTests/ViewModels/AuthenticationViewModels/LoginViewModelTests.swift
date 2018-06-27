//
//  LoginViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

// swiftlint:disable line_length

final class LoginViewModelTests: BaseUnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let loginViewModel = ViewModelsManager.loginViewModel()
        XCTAssertNotNil(loginViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(loginViewModel.email, "", "Initialization Falied")
        XCTAssertEqual(loginViewModel.password, "", "Initialization Falied")
        XCTAssertNil(loginViewModel.loginError.value, "Initialization Falied")
        XCTAssertFalse(loginViewModel.loginSuccess.value, "Initialization Falied")
    }
    
    
    // MARK: - Functional Tests
    func testLoginWithEmail() {
        let loginErrorExpectation = expectation(description: "Test Login Error")
        let loginExpectation = expectation(description: "Test Login")
        let loginViewModel = ViewModelsManager.loginViewModel()
        loginViewModel.loginError.bind { _ in
            loginViewModel.email = "testuser@tsl.io"
            loginViewModel.password = "1234"
            loginViewModel.loginWithEmail()
            loginErrorExpectation.fulfill()
        }
        loginViewModel.loginSuccess.bind { _ in
            loginExpectation.fulfill()
        }
        loginViewModel.loginWithEmail()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginWithFacebook() {
        let loginWithFacebookExpectation = expectation(description: "Test Login With Facebook")
        let loginViewModel = ViewModelsManager.loginViewModel()
        loginViewModel.loginError.bind { _ in
            XCTFail("Error Logging In With Facebook!")
            loginWithFacebookExpectation.fulfill()
        }
        loginViewModel.loginSuccess.bind { _ in
            loginWithFacebookExpectation.fulfill()
        }
        let redirectUrlWithQueryParameters = URL(string: "https://app.baseapp.tsl.io/?code=AQAf7IEllTmPlGXimVmK4A7ksXxRLU75FoiXO7lmc7sncGGvHG-o2_73Y5S2FrhPQvKicHm3kByu--Ou0hk2eRp9jFwArTrkbpXn2CljaG3BFWwNC6aSnruJmt-dHv1_9u-54xRYTSelP89WOqWGewEPWD5Sw1TgPiOXTHPebz3eiH43PTwm0KQhp2AFWSl7Q2zbkF0186yInZVL7JS4ms9phm8k7FF5OiEGBPMUFHMDzpCGewGmTAU5XJwGtZBiEitpftI6UmblIQQ0GuACm0S8qRTM_F5Xg2RBHFhZdw4-EgQ3qlQSxqfcwKZ9OxH4PP0#_=_")!
        loginViewModel.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
        loginViewModel.loginWithFacebook(email: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginWithLinkedIn() {
        let loginWithLinkedInExpectation = expectation(description: "Test Login With LinkedIn")
        let loginViewModel = ViewModelsManager.loginViewModel()
        loginViewModel.loginError.bind { _ in
            XCTFail("Error Logging In With LinkedIn!")
            loginWithLinkedInExpectation.fulfill()
        }
        loginViewModel.loginSuccess.bind { _ in
            loginWithLinkedInExpectation.fulfill()
        }
        let redirectUrlWithQueryParameters = URL(string: "https://app.baseapp.tsl.io/?code=AQREi3AZUQ0FEruGOrZwk8mtuaw7EnAr6S0XiAlMQT3lXi4J8pt7xD5ebEUye8PQwQY0FbdFK5NeFOmHyrW4w72SrNyCWQOujYtqXjx1G1IIDzjI4Ak&state=Av4WcUi9bZqFr1Ajk9GBBeLcVawFwqdi5MQaRtzTTitBta9WBMCJE2Qv1IwnNS")!
        loginViewModel.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
        loginViewModel.loginWithLinkedIn(email: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testOauth1InfoForTwitter() {
        let oauth1InfoForTwitterExpectation = expectation(description: "Test OAuth1 Info Twitter")
        let loginViewModel = ViewModelsManager.loginViewModel()
        loginViewModel.oauthStep1Error.bind { _ in
            XCTFail("Error Getting OAuth1 Info!")
            oauth1InfoForTwitterExpectation.fulfill()
        }
        loginViewModel.twitterOAuthUrl.bind { _ in
            oauth1InfoForTwitterExpectation.fulfill()
        }
        loginViewModel.oauth1InfoForTwitter()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginWithTwitter() {
        let oauth1InfoForTwitterExpectation = expectation(description: "Test OAuth1 Info Twitter")
        let loginWithTwitterExpectation = expectation(description: "Test Login With Twitter")
        let loginViewModel = ViewModelsManager.loginViewModel()
        loginViewModel.oauthStep1Error.bind { _ in
            XCTFail("Error Getting OAuth1 Info!")
            oauth1InfoForTwitterExpectation.fulfill()
            loginWithTwitterExpectation.fulfill()
        }
        loginViewModel.twitterOAuthUrl.bind { _ in
            let redirectUrlWithQueryParameters = URL(string: "https://app.baseapp.tsl.io/?redirect_state=hpZksuzwUGU04qHo4LjQJdoXCtt6mupP&oauth_token=0MxsWgAAAAAAwS-_AAABVld_DHo&oauth_verifier=qeXqTX5DrLTYstNiIKF62NHRUZwnepEu")!
            loginViewModel.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
            loginViewModel.loginWithTwitter(email: nil)
            oauth1InfoForTwitterExpectation.fulfill()
        }
        loginViewModel.loginSuccess.bind { _ in
            loginWithTwitterExpectation.fulfill()
        }
        loginViewModel.loginError.bind { _ in
            XCTFail("Error Logging In With Twitter!")
            loginWithTwitterExpectation.fulfill()
        }
        loginViewModel.oauth1InfoForTwitter()
        waitForExpectations(timeout: 10, handler: nil)
    }
}

// swiftlint:enable line_length
