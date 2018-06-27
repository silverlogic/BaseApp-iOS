//
//  BaseEndpointTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
@testable import Development
import XCTest

final class BaseEndpointInfoTests: BaseUnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let baseEndpointInfo = BaseEndpointInfo(path: "users/me",
                                                requestMethod: .get,
                                                parameters: nil,
                                                parameterEncoding: nil,
                                                requiresAuthorization: true)
        XCTAssertNotNil(baseEndpointInfo, "Value Should Not Be Nil!")
        XCTAssertEqual(baseEndpointInfo.path, "users/me", "Initialization Failed!")
        XCTAssertEqual(baseEndpointInfo.requestMethod, .get, "Initialization Failed!")
        XCTAssertNil(baseEndpointInfo.parameters, "Initialization Failed!")
        XCTAssertTrue(baseEndpointInfo.parameterEncoding is URLEncoding, "Initialization Failed!")
        XCTAssertTrue(baseEndpointInfo.requiresAuthorization, "Initialization Failed!")
    }
}
