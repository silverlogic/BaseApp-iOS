//
//  UserPaginator.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A paginator responsible for getting a paginated list of users that are registered.
final class UserPaginator: Paginator<User> {
    
    // MARK: - Public Instance Methods
    
    /// The search term to filter the user.
    var query: String?
    
    
    // MARK: - Public Instance Methods
    override func cleaningPredicate(for response: PaginatedResponse<User>) -> NSPredicate {
        return NSPredicate(value: false)
    }
    
    override func endpoint(with pagination: Pagination?) -> BaseEndpoint {
        return UserEndpoint.users(query: query, pagination: pagination)
    }
}
