//
//  Pagination.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import AlamofireCoreData
import Foundation

// MARK: - Pagination

/// A struct that incapsulates info for paginated responses.
struct Pagination: Wrapper {
    
    // MARK: - Public Instance Methods
    
    /// The total number of results in the pagination.
    var count: Int = 0
    
    /// The page number of the next page of results.
    var next: Int?
    
    /// The page number of the previous page of results.
    var previous: Int?
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `Pagination`. This is used to conform to the protocol `Wrapper`.
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        count <- map["count"]
        next <- (map["next"], Pagination.pageNumber)
        previous <- (map["previous"], Pagination.pageNumber)
    }
    
    
    // MARK: - Private Class Methods
    
    /// Takes a absolute string url that comes from the paginated response to get the query parameter `page`.
    ///
    /// - Note: This is what a absolute string url would look like:
    ///         `https://api.baseapp.tsl.io/v1/users?page=2`
    ///
    /// - Parameter absoluteString: A `String` representing the path to the next page of results
    /// - Returns: A `Int?` representing the value of the query parameter `page`. If not value exists, `nil`
    ///            will be returned.
    private static func pageNumber(absoluteString: String?) -> Int? {
        guard let string = absoluteString,
              let urlComponents = URLComponents(string: string),
              let queryItems = urlComponents.queryItems else { return nil }
        var pageNumber: Int?
        for queryItem in queryItems {
            switch (queryItem.name, queryItem.value) {
            case let ("page", string?):
                pageNumber = Int(string)
            default:
                continue
            }
        }
        return pageNumber
    }
}


// MARK: - Paginated Response

/// A struct that incapsulates a paginated response and its results
struct PaginatedResponse<T: ManyInsertable>: Wrapper {
    
    // MARK: - Public Instance Methods
    var pagination: Pagination!
    var results: Many<T>!
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `PaginatedResponse`. This is used to conform to the protocol `Wrapper`.
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        pagination <- map[.root]
        results <- map["results"]
    }
}
