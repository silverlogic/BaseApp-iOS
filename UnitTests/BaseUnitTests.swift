//
//  BaseAppV2UnitTests.swift
//  BaseAppV2UnitTests
//
//  Created by Emanuel  Guerrero on 4/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import OHHTTPStubs
import XCTest

/// A private enum with RESTful method types.
private enum TestHTTPMethod {
    case get
    case post
    case put
    case patch
    case delete
    case any
    
    /// Returns related to the HTTP method block from OHHTTPStubs.
    ///
    /// - Returns: An optionsl `OHHTTPStubsTestBlock`, related
    ///         to the current HTTP method.
    func stubBlock() -> OHHTTPStubsTestBlock? {
        switch self {
        case .get:
            return isMethodGET()
        case .post:
            return isMethodPOST()
        case .put:
            return isMethodPUT()
        case .patch:
            return isMethodPATCH()
        case .delete:
            return isMethodDELETE()
        case .any:
            return nil
        }
    }
}

class BaseUnitTests: XCTestCase {
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        registerStubs()
    }
    
    override func tearDown() {
        super.tearDown()
        CoreDataStack.shared.clearAll()
        clearStubs()
    }
}


// MARK: - Public Instance Methods
private extension BaseUnitTests {
    
    /// Registers stubs.
    func registerStubs() {
        func successfullFileResponse(_ fileName: String) -> OHHTTPStubsResponse {
            guard let path = OHPathForFile(fileName, type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            let response = OHHTTPStubsResponse(
                fileAtPath: path,
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
            return response
        }
        
        func successfullJSONResponse() -> OHHTTPStubsResponse {
            let response = OHHTTPStubsResponse(
                jsonObject: ["key": "value"],
                statusCode: 200,
                headers: ["Content-Type": "application/json"]
            )
            return response
        }
        
        _ = registerStub("/v1/users/me", for: .get) { _ in
            return successfullFileResponse("currentuser.json")
        }
        _ = registerStub("/v1/users/210", for: .patch) { _ in
            return successfullFileResponse("updateuser.json")
        }
        _ = registerStub("/v1/login", for: .post) { _ in
            return successfullFileResponse("loginuser.json")
        }
        _ = registerStub("/v1/register", for: .post) { _ in
            return successfullFileResponse("registeruser.json")
        }
        _ = registerStub("/v1/social-auth", for: .post) { _ in
            return successfullFileResponse("loginuseroauth.json")
        }
        _ = registerStub("/v1/social-auth", for: .post) { request in
            let nsUrlRequest = request as NSURLRequest
            let requestBody = nsUrlRequest.ohhttpStubs_HTTPBody()!
            let bodyString = String(data: requestBody, encoding: .utf8)!
            // swiftlint:disable line_length
            if bodyString == "{\"provider\":\"twitter\",\"redirect_uri\":\"https:\\/\\/app.baseapp.tsl.io\\/\"}" {
                return successfullFileResponse("oauth1response.json")
            }
            // swiftlint:enable line_length
            return successfullFileResponse("loginuseroauth.json")
        }
        _ = registerStub("/v1/forgot-password", for: .post) { _ in
            return successfullJSONResponse()
        }
        _ = registerStub("/v1/forgot-password/reset", for: .post) { _ in
            return successfullJSONResponse()
        }
        _ = registerStub("/v1/users", for: .get) { _ in
            return successfullFileResponse("userlistpage1.json")
        }
        _ = registerStub("/v1/users", for: .get, addition: containsQueryParams(["page": "2"])) { _ in
            return successfullFileResponse("userlistpage2.json")
        }
        _ = registerStub("/v1/change-email", for: .post) { _ in
            return successfullJSONResponse()
        }
        _ = registerStub("/v1/change-email/1/confirm", for: .post) { _ in
            return successfullJSONResponse()
        }
        _ = registerStub("/v1/change-email/1/verify", for: .post) { _ in
            return successfullJSONResponse()
        }
        _ = registerStub("/v1/users/change-password", for: .post) { _ in
            return successfullJSONResponse()
        }
        _ = registerStub("/v1/users/1/confirm-email", for: .post) { _ in
            return successfullJSONResponse()
        }
    }
    
    /// Clears stubs.
    func clearStubs() {
        OHHTTPStubs.removeAllStubs()
    }
    
    /// Returns stubbed block descriptor.
    ///
    /// - Parameters:
    ///   - path: An optional `String?`, representing URL path.
    ///   - httpMethod: A `TestHTTPMethod`, representing necessary HTTP method.
    ///   - addition: An optional `OHHTTPStubsTestBlock?` with addition condition.
    ///   - response: An escaping `OHHTTPStubsResponseBlock` handler.
    /// - Returns: An `OHHTTPStubsDescriptor` with stub descriptor.
    func registerStub(_ path: String?,
                      for httpMethod: TestHTTPMethod,
                      addition: OHHTTPStubsTestBlock? = nil,
                      response: @escaping OHHTTPStubsResponseBlock) -> OHHTTPStubsDescriptor {
        var condition = isHost((URL(string: ConfigurationManager.shared.apiUrl)?.host)!)
        if let path = path {
            condition = condition && isPath(path)
        }
        if let httpMethodBlock = httpMethod.stubBlock() {
            condition = condition && httpMethodBlock
        }
        if let addition = addition {
            condition = condition && addition
        }
        return stub(condition: condition, response: response)
    }
}
