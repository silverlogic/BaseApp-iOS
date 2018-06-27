//
//  FetchResults.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/20/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
import Foundation

// MARK: - Fetch Results Protocol

/// A protocol for defining state and behavior for fetching objects.
protocol FetchResultsProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// Binder that gets fired when an item was inserted.
    var itemInserted: DynamicBinderInterface<IndexPath?> { get }
    
    /// Binder that gets fired when an item was deleted.
    var itemDeleted: DynamicBinderInterface<IndexPath?> { get }
    
    /// Binder that gets fired when an item was updated.
    var itemUpdated: DynamicBinderInterface<IndexPath?> { get }
    
    /// Binder that gets fired when results began updating.
    var resultsBeganUpdate: DynamicBinderInterface<Void> { get }
    
    /// Binder that gets fired when resutls finished being updated.
    var resultsFinishedUpdate: DynamicBinderInterface<Void> { get }
    
    /// Binder that gets fired when an error occured with fetching.
    var fetchError: DynamicBinderInterface<BaseError?> { get }
}


// MARK: - FetchResultsProtocol Conformances

/// A generic class designed for fetching objects for a `UITableView`. This would be used in a view model. It
/// encapsulates all the functionality of working with a `NSFetchResultsController`.
final class FetchResults: NSObject, FetchResultsProtocol {
    
    // MARK: - FetchResultsProtocol Attributes
    var itemInserted: DynamicBinderInterface<IndexPath?> {
        return itemInsertedBinder.interface
    }
    var itemDeleted: DynamicBinderInterface<IndexPath?> {
        return itemDeletedBinder.interface
    }
    var itemUpdated: DynamicBinderInterface<IndexPath?> {
        return itemUpdatedBinder.interface
    }
    var resultsBeganUpdate: DynamicBinderInterface<Void> {
        return resultsBeganUpdateBinder.interface
    }
    var resultsFinishedUpdate: DynamicBinderInterface<Void> {
        return resultsFinishedUpdateBinder.interface
    }
    var fetchError: DynamicBinderInterface<BaseError?> {
        return fetchErrorBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate let fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>
    fileprivate var itemInsertedBinder: DynamicBinder<IndexPath?>
    fileprivate var itemDeletedBinder: DynamicBinder<IndexPath?>
    fileprivate var itemUpdatedBinder: DynamicBinder<IndexPath?>
    fileprivate var resultsBeganUpdateBinder: DynamicBinder<Void>
    fileprivate var resultsFinishedUpdateBinder: DynamicBinder<Void>
    fileprivate var fetchErrorBinder: DynamicBinder<BaseError?>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `FetchResults`.
    ///
    /// - Warning: If `fetchRequest` does not have any sort descriptors, the initializer will fail.
    ///
    /// - Parameters:
    ///     - fetchRequest: A `NSFetchRequest<NSFetchRequestResult>` representing the type to fetch for. The
    ///                     fetch request must have at least one sort descriptor.
    ///     - sectionNameKeyPath: A `String` representing the a key path that returns the section name. Pass
    ///                           `nil` to indicate that a single section should be generated.
    ///     - cacheName: A `String` representing the name of the cache file the receiver should use. Pass
    ///                  `nil` to prevent caching.
    init?(with fetchRequest: NSFetchRequest<NSFetchRequestResult>,
          sectionNameKeyPath: String?,
          cacheName: String?) {
        guard let sortDescriptors = fetchRequest.sortDescriptors,
              sortDescriptors.count >= 1 else { return nil }
        itemInsertedBinder = DynamicBinder(nil)
        itemDeletedBinder = DynamicBinder(nil)
        itemUpdatedBinder = DynamicBinder(nil)
        resultsBeganUpdateBinder = DynamicBinder(())
        resultsFinishedUpdateBinder = DynamicBinder(())
        fetchErrorBinder = DynamicBinder(nil)
        let objectContext = CoreDataStack.shared.managedObjectContext
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: objectContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
        super.init()
        fetchResultsController.delegate = self
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension FetchResults: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        resultsBeganUpdateBinder.value = ()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        resultsFinishedUpdateBinder.value = ()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let path = newIndexPath else { return }
            itemInsertedBinder.value = path
        case .delete:
            guard let path = indexPath else { return }
            itemDeletedBinder.value = path
        case .move:
            if let path = indexPath {
                itemDeletedBinder.value = path
            }
            if let path = newIndexPath {
                itemInsertedBinder.value = path
            }
        case .update:
            guard let path = indexPath else { return }
            itemUpdatedBinder.value = path
        }
    }
}


// MARK: - Public Instance Methods
extension FetchResults {

    /// Begins fetching the objects.
    ///
    /// - Note: If an error occurs, it will be logged to the console.
    func beginFetchingObjects() {
        do {
            try fetchResultsController.performFetch()
        } catch {
            AppLogger.shared.logMessage(error.localizedDescription, for: .error)
            fetchErrorBinder.value = BaseError.fetchResultsError
        }
    }
    
    /// Gets the total amount of objects fetched.
    ///
    /// - Returns: An `Int` representing the total amount of objects. If there aren't objects at all, zero
    ///            would be returned.
    func numberOfObjects() -> Int {
        guard let fetchedObjects = fetchResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }

    ///  Gets the number of sections that the fetch results controller contains.
    ///
    /// - Returns: An `Int` representing the total number of sections. If there aren't any, zero would be
    ///            returned.
    func numberOfSections() -> Int {
        guard let sections = fetchResultsController.sections else { return 0 }
        return sections.count
    }
    
    /// Gets the number of rows in a section of the fetch results controller.
    ///
    /// - Parameter sectionIndex: An `Int` representing the section.
    /// - Returns: An `Int` representing the total number of rows. If there aren't any sections, zero will be
    ///            returned.
    func numberOfRowsForSection(_ sectionIndex: Int) -> Int {
        guard let sections = fetchResultsController.sections,
              let section = sections[safe: sectionIndex] else { return 0 }
        return section.numberOfObjects
    }

    /// Gets an item from the fetch results controller.
    ///
    /// - Parameter indexPath: An `IndexPath` representing the location of the item.
    /// - Returns: A `T` representing the retrieved object. `nil` could be returned if an error occured.
    func itemAtIndexPath<T: NSManagedObject>(_ indexPath: IndexPath) -> T? {
        guard let object = fetchResultsController.object(at: indexPath) as? T else { return nil }
        return object
    }
}
