//
//  NSManagedObject+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
import Foundation

// MARK: - MockableManagedObject
extension NSManagedObject: MockableManagedObject {}


// MARK: - Public Instance Methods
extension NSManagedObject {
    
    /// Updates the persistent properties of a managed object
    /// to use the latest values from the persistent store.
    func cancelChanges() {
        managedObjectContext?.refresh(self, mergeChanges: false)
    }
}


// MARK: - Public Class Attributes
extension NSManagedObject {
    
    /// The `String` representation of the class name.
    static var entityName: String {
        return String(describing: self)
    }
}
