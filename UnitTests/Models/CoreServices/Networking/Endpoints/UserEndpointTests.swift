//
//  UserEndpointTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
@testable import Development
import XCTest

final class UserEndpointTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testUserEndpoint() {
        let userEndpoint = UserEndpoint.user(userId: 1)
        XCTAssertNotNil(userEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(userEndpoint.endpointInfo.path, "users/1", "Path Not Correct!")
        XCTAssertEqual(userEndpoint.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNotNil(userEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(userEndpoint.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct!")
        XCTAssertFalse(userEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
    
    func testUsersEndpoint() {
        let usersEndpoint = UserEndpoint.users(query: nil, pagination: nil)
        XCTAssertNotNil(usersEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(usersEndpoint.endpointInfo.path, "users", "Path Not Correct!")
        XCTAssertEqual(usersEndpoint.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNotNil(usersEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(usersEndpoint.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct!")
        XCTAssertFalse(usersEndpoint.endpointInfo.requiresAuthorization, "Value Should Be False!")
    }
}
