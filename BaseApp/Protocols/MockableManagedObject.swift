//
//  MockableManagedObject.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 1/2/18.
//  Copyright © 2018 SilverLogic. All rights reserved.
//

import CoreData
import Foundation

// MARK: - Mockable Managed Object Protocol

/// A protocol that defines state and behavior for generating mock instances of an `NSManagedObject` and its
/// subclasses.
protocol MockableManagedObject {}


// MARK: - MockableManagedObject Default Implementation For NSManagedObject
extension MockableManagedObject where Self: NSManagedObject {
    
    /// Generates a mock instance of a `NSManagedObject`.
    ///
    /// - Returns: A `Self?` representing the instance.
    static func mockInstance() -> Self? {
        let objectSpace = CoreDataStack.shared.managedObjectContext
        return NSEntityDescription.insertNewObject(forEntityName: Self.entityName, into: objectSpace) as? Self
    }
}
