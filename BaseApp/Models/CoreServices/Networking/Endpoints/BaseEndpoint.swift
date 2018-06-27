//
//  BaseEndpoint.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
import Foundation
import Raccoon

// MARK: - Base Endpoint Protocol

/// A subprotocol of `Raccoon.Endpoint` for building endpoints.
protocol BaseEndpoint: Raccoon.Endpoint {
    var endpointInfo: BaseEndpointInfo { get }
}


// MARK: - BaseEndpoint Raccoon.Endpoint
extension BaseEndpoint {
    func request(withBaseURL baseURL: String) -> DataRequest {
        let url = URL(base: baseURL, path: endpointInfo.path)!
        let headers: HTTPHeaders?
        if endpointInfo.requiresAuthorization, let token = SessionManager.shared.authorizationToken {
            headers = ["Authorization": "Token \(token)"]
        } else {
            headers = nil
        }
        return Alamofire.request(url,
                                 method: endpointInfo.requestMethod,
                                 parameters: endpointInfo.parameters,
                                 encoding: endpointInfo.parameterEncoding,
                                 headers: headers)
    }
}


// MARK: - Base Endpoint Info

/// A struct encapsulating all required info needed for building requests from an endpoint.
struct BaseEndpointInfo {
    
    // MARK: - Public Instance Attributes
    let path: String
    let requestMethod: Alamofire.HTTPMethod
    let parameters: Parameters?
    let parameterEncoding: Alamofire.ParameterEncoding
    let requiresAuthorization: Bool
    
    
    // MARK: - Initializers
    
    /**
        Initializes a new instance of `BaseEndpointInfo`.
     
        - Parameters:
            - path: A `String` representing the path of the request.
            - requestMethod: A `HTTPMethod` representing the verb of
                             the request.
            - parameters: A `Parameters` representing the parameters
                          that will be sent in the request. `nil` can
                          be passed if no parameters are needed.
            - parameterEncoding: A `ParameterEncoding` representing how 
                                 the parameters would be encoded in the
                                 request. If `nil` is passed, `URLEncoding`
                                 will be used for `GET` requests. This means
                                 the parameters will be added to the request
                                 as query parameters. For all other requests,
                                 `JSONEncoding` will be used.
            - requiresAuthorization: A `Bool` indicating if the request needs
                                     to be authorized. If `true`, the authorization
                                     token storied stored locally on the device will
                                     be added to the header.
    */
    
    
    /// Initializes a new instance of `BaseEndpointInfo`.
    ///
    /// - Parameters:
    ///   - path: A `String` representing the path of the request.
    ///   - requestMethod: A `HTTPMethod` representing the verb of the request.
    ///   - parameters: A `Parameters` representing the parameters that will be sent in the request. `nil` can
    ///                 be passed if no parameters are needed.
    ///   - parameterEncoding: A `ParameterEncoding` representing how the parameters would be encoded in the
    ///                        request. If `nil` is passed, `URLEncoding` will be used for `GET` requests.
    ///                        This means the parameters will be added to the request as query parameters. For
    ///                        all other requests, `JSONEncoding` will be used.
    ///   - requiresAuthorization: A `Bool` indicating if the request needs to be authorized. If `true`, the
    ///                            authorization token stored locally on the device will be added to the
    ///                            header.
    init(path: String,
         requestMethod: HTTPMethod,
         parameters: Parameters?,
         parameterEncoding: ParameterEncoding?,
         requiresAuthorization: Bool) {
        self.path = path
        self.requestMethod = requestMethod
        self.parameters = parameters
        if let encoding = parameterEncoding {
            self.parameterEncoding = encoding
        } else {
            switch requestMethod {
            case .get:
                self.parameterEncoding = URLEncoding()
            default:
                self.parameterEncoding = JSONEncoding()
            }
        }
        self.requiresAuthorization = requiresAuthorization
    }
}
