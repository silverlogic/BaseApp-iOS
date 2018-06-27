//
//  NetworkClient.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
import AlamofireActivityLogger
import CoreData
import Foundation
import PromiseKit
import Raccoon

// MARK: - Network Client

/// A class responsible for handling network requests going out of the application.
final class NetworkClient: Raccoon.Client {
    
    // MARK: - Public Instance Attributes
    public var baseURL: String
    public var context: NSManagedObjectContext
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `NetworkClient` with a given base url and a context to insert objects in to
    /// when working with Groot dependency.
    ///
    /// - Parameters:
    ///   - baseUrl: A `String` representing the base url of all requests. When enqueing requests, endpoints
    ///              would be appended to the base url.
    ///   - manageObjectContext: A `NSManagedObjectContext` representing the object space that objects would
    ///                          be inserted or updated to.
    init(baseUrl: String, manageObjectContext: NSManagedObjectContext) {
        baseURL = baseUrl
        context = manageObjectContext
    }
    
    
    // MARK: - Raccoon.Client
    func prepare(_ request: DataRequest, for endpoint: Endpoint) -> DataRequest {
        #if DEBUG
            return request
                   .validateResponse()
                   .log(level: .all, printer: NetworkLogger())
        #else
            return request.validateResponse()
        #endif
    }
    
    func process<T>(_ promise: Promise<T>, for endpoint: Endpoint) -> Promise<T> {
        return promise.then { (item) -> T in
            try? self.context.save()
            return item
        }
    }
}


// MARK: - Network Logger

/// A class responsible for printing to `AppLogger`.
private class NetworkLogger: Printer {
    fileprivate func print(_ string: String, phase: Phase) {
        if phase.isError {
            AppLogger.shared.logMessage(string, for: .error)
        } else {
            AppLogger.shared.logMessage(string, for: .debug, debugOnly: true)
        }
    }
}
