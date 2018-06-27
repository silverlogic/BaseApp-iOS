//
//  APIErrorTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class BaseErrorTests: BaseUnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let apiError = BaseError(statusCode: 400, errorDescription: "Email entered not correct!")
        XCTAssertNotNil(apiError, "Value Should Not Be Nil!")
        XCTAssertEqual(apiError.statusCode, 400, "Initialization Failed!")
        XCTAssertEqual(apiError.errorDescription, "Email entered not correct!", "Initialization Failed!")
    }
    
    
    // MARK: - Functional Tests
    func testErrorDescriptionFromErrorDictionary() {
        let dictionary = ["username": ["Username already in use."]]
        let usernameError = BaseError.errorDescriptionFromErrorDictionary(dictionary)
        XCTAssertEqual(usernameError, "Username already in use. 😞", "Getting Error Description Failed!")
        let unidentifiedError = BaseError.errorDescriptionFromErrorDictionary(["age": ["Age not supported."]])
        XCTAssertEqual(unidentifiedError,
                       "Oh no, an unknown error occured. 😞",
                       "Getting Error Description Failed!")
    }
    
    func testGeneric() {
        let genericError = BaseError.generic
        XCTAssertNotNil(genericError, "Value Should Not Be Nil!")
        XCTAssertEqual(genericError.statusCode, 0, "Getting Error Failed!")
        XCTAssertEqual(genericError.errorDescription,
                       "Oh no, an unknown error occured. 😞",
                       "Getting Error Failed!")
    }
    
    func testFieldsEmpty() {
        let fieldsEmptyError = BaseError.fieldsEmpty
        XCTAssertNotNil(fieldsEmptyError, "Value Should Not Be Nil!")
        XCTAssertEqual(fieldsEmptyError.statusCode, 101, "Getting Error Failed!")
        XCTAssertEqual(fieldsEmptyError.errorDescription,
                       "Oops, not all fields enterd. 😞",
                       "Getting Error Failed!")
    }
    
    func testPasswordsDoNotMatch() {
        let passwordsDoNotMatchError = BaseError.passwordsDoNotMatch
        XCTAssertNotNil(passwordsDoNotMatchError, "Value Should Not Be Nil!")
        XCTAssertEqual(passwordsDoNotMatchError.statusCode, 102, "Getting Error Failed!")
        XCTAssertEqual(passwordsDoNotMatchError.errorDescription,
                       "Oops, passwords entered don't match. 😞",
                       "Getting Error Failed!")
    }
    
    func testEmailNeededForOAuth() {
        let emailNeededForOAuthError = BaseError.emailNeededForOAuth
        XCTAssertNotNil(emailNeededForOAuthError, "Value Should Not Be Nil!")
        XCTAssertEqual(emailNeededForOAuthError.statusCode, 103, "Getting Error Failed!")
        XCTAssertEqual(emailNeededForOAuthError.errorDescription,
                       "Please enter an email to continue. 🤔",
                       "Getting Error Failed!")
    }
    
    func testEmailAlreadyInUseForOAuth() {
        let emailAlreadyInUseForOAuthError = BaseError.emailAlreadyInUseForOAuth
        XCTAssertNotNil(emailAlreadyInUseForOAuthError, "Value Should Not Be Nil!")
        XCTAssertEqual(emailAlreadyInUseForOAuthError.statusCode, 104, "Getting Error Failed!")
        XCTAssertEqual(emailAlreadyInUseForOAuthError.errorDescription,
                       "Oops, the email associated is already in use. 😞",
                       "Getting Error Failed!")
    }
    
    func testEmailNeededForOAuthFacebook() {
        let emailNeededForOAuthFacebookError = BaseError.emailNeededForOAuthFacebook
        XCTAssertNotNil(emailNeededForOAuthFacebookError, "Value Should Not Be Nil!")
        XCTAssertEqual(emailNeededForOAuthFacebookError.statusCode, 105, "Getting Error Failed!")
        XCTAssertEqual(emailNeededForOAuthFacebookError.errorDescription,
                       "Please enter an email to continue. 🤔",
                       "Getting Error Failed!")
    }
    
    func testEmailNeededForOAuthLinkedIn() {
        let emailNeededForOAuthLinkedInError = BaseError.emailNeededForOAuthLinkedIn
        XCTAssertNotNil(emailNeededForOAuthLinkedInError, "Value Should Not Be Nil!")
        XCTAssertEqual(emailNeededForOAuthLinkedInError.statusCode, 106, "Getting Error Failed!")
        XCTAssertEqual(emailNeededForOAuthLinkedInError.errorDescription,
                       "Please enter an email to continue. 🤔",
                       "Getting Error Failed!")
    }
    
    func testEmailNeededForOAuthTwitter() {
        let emailNeededForOAuthTwitterError = BaseError.emailNeededForOAuthTwitter
        XCTAssertNotNil(emailNeededForOAuthTwitterError, "Value Should Not Be Nil!")
        XCTAssertEqual(emailNeededForOAuthTwitterError.statusCode, 107, "Getting Error Failed!")
        XCTAssertEqual(emailNeededForOAuthTwitterError.errorDescription,
                       "Please enter an email to continue. 🤔",
                       "Getting Error Failed!")
    }
    
    func testEndOfPagination() {
        let endOfPaginationError = BaseError.endOfPagination
        XCTAssertNotNil(endOfPaginationError, "Value Should Not Be Nil!")
        XCTAssertEqual(endOfPaginationError.statusCode, 108, "Getting Error Failed!")
        XCTAssertEqual(endOfPaginationError.errorDescription,
                       "Looks like there aren't anymore. 😜",
                       "Getting Error Failed!")
    }
    
    func testStillLoadingResults() {
        let stillLoadingResultsError = BaseError.stillLoadingResults
        XCTAssertNotNil(stillLoadingResultsError, "Value Should Not Be Nil!")
        XCTAssertEqual(stillLoadingResultsError.statusCode, 109, "Getting Error Failed!")
        XCTAssertEqual(stillLoadingResultsError.errorDescription,
                       "Results Are Still Loading. 😜",
                       "Getting Error Failed!")
    }
    
    func testNewEmailConfirmed() {
        let newEmailConfirmedError = BaseError.newEmailConfirmed
        XCTAssertNotNil(newEmailConfirmedError, "Value Should Not Be Nil!")
        XCTAssertEqual(newEmailConfirmedError.statusCode, 110, "Getting Error Failed!")
        XCTAssertEqual(newEmailConfirmedError.errorDescription,
                       "You need to check your email. 😜",
                       "Getting Error Failed!")
    }
    
    func testFetchResultsError() {
        let fetchResultsError = BaseError.fetchResultsError
        XCTAssertNotNil(fetchResultsError, "Value Should Not Be Nil!")
        XCTAssertEqual(fetchResultsError.statusCode, 111, "Getting Error Failed!")
        XCTAssertEqual(fetchResultsError.errorDescription,
                       "Error fetching objects from store. 😞",
                       "Getting Error Failed!")
    }
}
