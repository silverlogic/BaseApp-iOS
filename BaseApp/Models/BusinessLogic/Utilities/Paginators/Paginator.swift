//
//  Paginator.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 10/27/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
import Foundation
import Raccoon

// MARK: - Paginator Loading State Enum

/// An enum that declares different loading states of a paginator.
enum PaginatorLoadingState {
    case notLoading
    case loadiing
}


// MARK: - Paginator Protocol

/// A protocol that defines state and behavior for retrieving a paginated list.
protocol PaginatorProtocol: class {
    
    // MARK: - Associated Type
    
    /// The class of the model we are getting.
    associatedtype Model: NSManagedObject
    
    
    // MARK: - Public Instance Attributes
    
    /// The next pagination that must be performed.
    var nextPagination: Pagination? { get set }
    
    /// Indicates the loading state.
    var loadingState: PaginatorLoadingState { get set }
    
    /// The total value of items.
    var total: Int? { get set }
    
    /// A closure that can be invoked for canceling the current request.
    var cancel: (() -> Void)? { get set }
    
    
    // MARK: - Public Instance Methods
    
    /// Gives a predicate to filter the objects that should be removed if fetching objects with the clean
    /// option.
    ///
    /// - Parameter response: A `PaginatedResponse<Model>` representing the type of response.
    /// - Returns: A `NSPredicate` representing the predicate to use for clearing.
    func cleaningPredicate(for response: PaginatedResponse<Model>) -> NSPredicate
    
    /// The endpoint to use for retrieivng paginated responses.
    ///
    /// - Parameter pagination: A `Pagination` representing the pagination to use.
    /// - Returns: A `BaseEndpoint` representing the endpoint to use for pagination.
    func endpoint(with pagination: Pagination?) -> BaseEndpoint
}


// MARK: - PaginatorProtocol Public Instance Methods
extension PaginatorProtocol {
    
    /// Gets a paginated list of objects.
    ///
    /// - Parameters:
    ///   - shouldClean: A `Bool` indicating if the object space that contains instances of `NSManagedObject
    ///                  should be removed except for ones received from the API.
    ///   - success: A closure that gets invoked when getting the paginated list was successful.
    ///   - failure: A closure that gets invoked when getting the paginated list failed.
    func fetchNextPage(shouldClean: Bool,
                       success: @escaping (_ objects: [Model]) -> Void,
                       failure: @escaping (_ error: BaseError) -> Void) {
        if loadingState == .loadiing {
            failure(BaseError.stillLoadingResults)
            return
        }
        loadingState = .loadiing
        if shouldClean {
            nextPagination = nil
        }
        if let pagination = nextPagination, pagination.next == nil {
            loadingState = .notLoading
            failure(BaseError.endOfPagination)
            return
        }
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            let endpoint = strongSelf.endpoint(with: strongSelf.nextPagination)
            let cancellable: Cancellable<PaginatedResponse<Model>> = networkClient
                .cancellableEnqueue(endpoint)
            strongSelf.cancel = cancellable.cancel
            cancellable.promise
            .then(on: dispatchQueue) { (response: PaginatedResponse<Model>) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.total = response.pagination.count
                if shouldClean {
                    strongSelf.cleanOldObjects(for: response, success: success, failure: failure)
                    return
                }
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    strongSelf.nextPagination = response.pagination
                    strongSelf.loadingState = .notLoading
                    success(response.results.array)
                }
            }
            .catchAPIError(queue: DispatchQueue.main,
                           policy: .allErrorsExceptCancellation) { (error: BaseError) in
                guard let strongSelf = self else { return }
                strongSelf.loadingState = .notLoading
                failure(error)
            }
        }
    }
    
    /// Cancels the current request
    func cancelCurrentRequest() {
        loadingState = .notLoading
        cancel?()
    }
}


// MARK: - PaginatorProtocol Private Instance Methods
private extension PaginatorProtocol {
    
    /// Removes the old objects from the object space before returning the new objects.
    ///
    /// - Parameters:
    ///   - response: A `PaginatedResponse<Model>` representing the response that was retrieved.
    ///   - success: A closure that gets invoked when getting the paginated list was successful.
    ///   - failure: A closure that gets invoked when getting the paginated list failed.
    func cleanOldObjects(for response: PaginatedResponse<Model>,
                         success: @escaping (_ objects: [Model]) -> Void,
                         failure: @escaping (_ error: BaseError) -> Void) {
        let predicate = cleaningPredicate(for: response)
        let fetchRequest = NSFetchRequest<Model>(entityName: Model.entityName)
        fetchRequest.predicate = predicate
        CoreDataStack.shared.fetchObjects(fetchRequest: fetchRequest, success: { (objects: [Model]) in
            let dispatchGroup = DispatchGroup()
            objects.forEach {
                dispatchGroup.enter()
                CoreDataStack.shared.deleteObject($0, success: {
                    dispatchGroup.leave()
                }, failure: {
                    dispatchGroup.leave()
                })
            }
            dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.nextPagination = response.pagination
                strongSelf.loadingState = .notLoading
                success(response.results.array)
            }
        }, failure: {
            DispatchQueue.main.async {
                failure(BaseError.generic)
            }
        })
    }
}


// MARK: - PaginatorProtocol Conformances

/// A class that conforms to `PaginatorProtocol` and implements it.
///
/// - Warning: Subclasses must override `endpoint(with:)` or a `fatalError` will be invoked.
class Paginator<Model: NSManagedObject>: PaginatorProtocol {
    
    // MARK: - PaginatorProtocol Attributes
    var total: Int?
    var loadingState: PaginatorLoadingState = .notLoading
    var nextPagination: Pagination?
    var cancel: (() -> Void)?
    
    
    // MARK: - PaginatorProtocol Methods
    func cleaningPredicate(for response: PaginatedResponse<Model>) -> NSPredicate {
        return NSPredicate(format: "NOT self in %@", response.results.array)
    }
    
    func endpoint(with pagination: Pagination?) -> BaseEndpoint {
        fatalError("Class \(String(describing: type(of: self))) must override `endpoint(with:)`")
    }
}
