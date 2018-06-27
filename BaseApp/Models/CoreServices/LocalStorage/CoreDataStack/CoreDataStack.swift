//
//  CoreDataStack.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
import Foundation

/// A singleton responsible for managing, insertion, deletion, and fetching objects from the Core Data stack.
final class CoreDataStack {
    
    // MARK: - Shared Instance
    static let shared = CoreDataStack()
    
    
    // MARK: - Private Instance Attributes
    fileprivate var _managedObjectContext: NSManagedObjectContext!
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `CoreDataStack`.
    private init() {
        initializeCoreDataStack()
    }
}


// MARK: - Getters & Setters
extension CoreDataStack {
    
    /// The current object space being used.
    var managedObjectContext: NSManagedObjectContext {
        return _managedObjectContext
    }
}


// MARK: - Public Instance Methods
extension CoreDataStack {
    
    /// Generic method for fetching objects from the current object space.
    ///
    /// - Note: When calling this method, it can be called on the main thread since it internally will go on
    ///         a background thread for fetching.
    ///
    /// - Parameters:
    ///   - fetchRequest: A `NSFetchRequest<T>` representing how the objects should be fetched from the object
    ///                   store.
    ///   - success: A closure that gets invoked when retreiving the objects was successful. Passes an `[T]`
    ///              representing the results of the fetch.
    ///   - failure: A closure that gets invoked when retreving the objects failed.
    func fetchObjects<T: NSManagedObject>(fetchRequest: NSFetchRequest<T>,
                                          success: @escaping (_ objects: [T]) -> Void,
                                          failure: @escaping () -> Void) {
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result) in
            DispatchQueue.main.async {
                guard let objects = result.finalResult else {
                    failure()
                    return
                }
                success(objects)
            }
        }
        do {
            try _managedObjectContext.execute(asyncFetchRequest)
        } catch {
            AppLogger.shared.logMessage(error.localizedDescription, for: .error)
            failure()
        }
    }
    
    /// Generic method for deleting an object from the current object space.
    ///
    /// - Parameters:
    ///   - object: A `T` indicating the entity to delete.
    ///   - success: A closure that gets invoked when deleting was successful. `nil` can be passed as a
    ///              parameter.
    ///   - failure: A closure that gets invoked when deleting failed. The object space doesn't change if
    ///              deleting failed. `nil` can be passed as a parameter.
    func deleteObject<T: NSManagedObject>(_ object: T, success: (() -> Void)?, failure: (() -> Void)?) {
        _managedObjectContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf._managedObjectContext.delete(object)
            do {
                if strongSelf._managedObjectContext.hasChanges {
                    try strongSelf._managedObjectContext.save()
                    DispatchQueue.main.async {
                        guard let closure = success else { return }
                        closure()
                    }
                }
            } catch {
                AppLogger.shared.logMessage(error.localizedDescription, for: .error)
                DispatchQueue.main.async {
                    guard let closure = failure else { return }
                    closure()
                }
            }
        }
    }
    
    /// Generic method for inserting an object into the current object space.
    ///
    /// - Parameters:
    ///   - entityModel: A `T.Type` representing the type of entity model to insert.
    ///   - success: A closure that gets invoked when inserting the object and saving was successful. Passes
    ///              the newly created object for use.
    ///   - failure: A closure that gets invoked when inserting failed.
    func insertObject<T: NSManagedObject>(for entityModel: T.Type,
                                          success: @escaping (_ object: T) -> Void,
                                          failure: @escaping () -> Void) {
        guard let entityDescripion = NSEntityDescription.entity(forEntityName: T.entityName,
                                                                in: _managedObjectContext),
              let model = NSManagedObject(entity: entityDescripion,
                                          insertInto: _managedObjectContext) as? T else {
                failure()
                return
        }
        saveCurrentState(success: { 
            success(model)
        }) { 
            failure()
        }
    }
    
    /// Saves the current state of the object space.
    ///
    /// - Parameters:
    ///   - success: A closure that gets invoked when successful.
    ///   - failure: A closure that gets invoked when saving fails.
    func saveCurrentState(success: @escaping () -> Void, failure: @escaping () -> Void) {
        do {
            try _managedObjectContext.save()
            success()
        } catch {
            AppLogger.shared.logMessage(error.localizedDescription, for: .error)
            failure()
        }
    }
    
    /// Clears all objects in the object space.
    ///
    /// - Warning: This method should only be used in unit tests for reseting and starting on a clean state.
    func clearAll() {
        _managedObjectContext.reset()
    }
}


// MARK: - Private Instance Methods
fileprivate extension CoreDataStack {
    
    /// Initializes the Core Data Stack.
    ///
    /// - Warning: If an error occurs during the setup process, a `fatalError` gets thrown with a description
    ///            of what caused the error.
    fileprivate func initializeCoreDataStack() {
        guard let modelUrl = Bundle.main.url(forResource: CoreDataStackConstants.model,
                                             withExtension: CoreDataStackConstants.modelType),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            AppLogger.shared.logMessage("Error Loading Model From Main Bundle!", for: .error)
            fatalError("Error Loading Model From Main Bundle!")
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        _managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // Check if running in unit test target
        if ProcessInfo.isRunningUnitTests || ProcessInfo.isRunningIntegrationTests {
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType,
                                                                  configurationName: nil,
                                                                  at: nil,
                                                                  options: nil)
            } catch {
                fatalError("Error Setting Up Stack For Unit Tests!")
            }
            self._managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        } else {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            guard let documentUrl = urls.last else {
                AppLogger.shared.logMessage("Error Getting Document Directory Url!", for: .error)
                fatalError("Error Getting Document Directory Url!")
            }
            let coreDataStoreUrl = documentUrl.appendingPathComponent(CoreDataStackConstants.sqLite)
            let migrationOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                                    NSInferMappingModelAutomaticallyOption: true]
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                  configurationName: nil,
                                                                  at: coreDataStoreUrl,
                                                                  options: migrationOptions)
            } catch {
                AppLogger.shared.logMessage("Error Performing Core Data Store Migration!", for: .error)
                fatalError("Error Performing Core Data Store Migration!")
            }
            _managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        }
    }
}
