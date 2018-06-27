//
//  UserEndpoint.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
import AlamofireCoreData
import Foundation

/// An enum that conforms to `BaseEndpoint`. It defines endpoints that would be used for retreving users.
enum UserEndpoint: BaseEndpoint {
    case user(userId: Int)
    case users(query: String?, pagination: Pagination?)
    
    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        var parameters: Alamofire.Parameters = [:]
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .user(userId):
            path = "users/\(userId)"
            requestMethod = .get
            parameterEncoding = nil
            requiresAuthorization = false
        case let .users(query, pagination):
            path = "users"
            requestMethod = .get
            parameters["page"] = pagination?.next
            if let query = query, !query.isEmpty {
                parameters["q"] = query
            }
            parameterEncoding = nil
            requiresAuthorization = false
        }
        return BaseEndpointInfo(
            path: path,
            requestMethod: requestMethod,
            parameters: parameters,
            parameterEncoding: parameterEncoding,
            requiresAuthorization: requiresAuthorization
        )
    }
}
