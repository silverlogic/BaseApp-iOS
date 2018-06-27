//
//  UserFeedViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - User Feed ViewModel Protocol

/// A protocol for defining state and behavior for displaying users in a feed.
protocol UserFeedViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// Binder that gets fired when the number of available users.
    var numberOfUsers: DynamicBinderInterface<Int> { get }
    
    /// Binder that gets fired when new users are ready to add to the collection view.
    var insertionPositions: DynamicBinderInterface<[IndexPath]?> { get }
    
    /// Binder that gets fired when an error occured with fetching users.
    var fetchUsersError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when there are no more users.
    var endOfUsers: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    
    /// Fetches the list of users
    ///
    /// - Parameter clean: A `Bool` indicating if the cache of users on the disk should be cleaned.
    func fetchUsers(clean: Bool)
    
    /// Gets a user with a given index.
    ///
    /// - Parameter index: An `Int` representing the position of the user in the data source.
    /// - Returns: A `User?` representing the user in the data source.
    func userWithIndex(_ index: Int) -> User?
}


/// MARK: - UserFeedViewModelProtocol Conformances

/// A class that conforms to `UserFeedViewModelProtocol` and implements it.
private final class UserFeedViewModel: UserFeedViewModelProtocol {
    
    // MARK: - UserFeedViewModelProtocol Attributes
    var numberOfUsers: DynamicBinderInterface<Int> {
        return numberOfUsersBinder.interface
    }
    var insertionPositions: DynamicBinderInterface<[IndexPath]?> {
        return insertionPositionsBinder.interface
    }
    var fetchUsersError: DynamicBinderInterface<BaseError?> {
        return fetchUsersErrorBinder.interface
    }
    var endOfUsers: DynamicBinderInterface<Bool> {
        return endOfUsersBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var users: [User]
    private var userPaginator: UserPaginator
    private var numberOfUsersBinder: DynamicBinder<Int>
    private var insertionPositionsBinder: DynamicBinder<[IndexPath]?>
    private var fetchUsersErrorBinder: DynamicBinder<BaseError?>
    private var endOfUsersBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `UserFeedViewModel`.
    init() {
        numberOfUsersBinder = DynamicBinder(0)
        insertionPositionsBinder = DynamicBinder(nil)
        fetchUsersErrorBinder = DynamicBinder(nil)
        endOfUsersBinder = DynamicBinder(false)
        users = [User]()
        userPaginator = UserPaginator()
    }
    
    
    // MARK: - UserFeedViewModelProtocol Methods
    func fetchUsers(clean: Bool) {
        userPaginator.fetchNextPage(shouldClean: clean, success: { [weak self] (fetchedUsers) in
            guard let strongSelf = self else { return }
            if clean {
                strongSelf.users = []
            }
            var indexPaths: [IndexPath]?
            if strongSelf.users.isEmpty {
                strongSelf.users.append(contentsOf: fetchedUsers)
                strongSelf.numberOfUsersBinder.value = strongSelf.users.count
            } else {
                strongSelf.users.append(contentsOf: fetchedUsers)
                strongSelf.numberOfUsersBinder.value = strongSelf.users.count
                let insertionPositions = strongSelf.users.count - fetchedUsers.count
                indexPaths = [IndexPath]()
                for index in insertionPositions..<strongSelf.users.count {
                    indexPaths?.append(IndexPath(item: index, section: 0))
                }
            }
            strongSelf.insertionPositionsBinder.value = indexPaths
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 108 {
                strongSelf.endOfUsersBinder.value = true
            } else if error.statusCode == 109 {
                return
            } else {
                strongSelf.fetchUsersErrorBinder.value = error
            }
        }
    }
    
    func userWithIndex(_ index: Int) -> User? {
        return users[safe: index]
    }
}


// MARK: - ViewModelManager Class Extension

/// A `ViewModelsManager` class extension for `UserFeedViewModelProtocol`.
extension ViewModelsManager {
    
    /// Returns an instance conforming to `UserFeedViewModelProtocol`.
    ///
    /// - Returns: an instance conforming to `UserFeedViewModelProtocol`.
    class func userFeedViewModel() -> UserFeedViewModelProtocol {
        return UserFeedViewModel()
    }
}
