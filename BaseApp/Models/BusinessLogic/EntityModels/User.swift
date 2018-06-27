//
//  User.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/2/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
import Foundation

/// A class entity representing a user of the application.
final class User: NSManagedObject {
    
    // MARK: - Private Instance Attributes
    @NSManaged fileprivate var avatar: String?
    
    
    // MARK: - Public Instance Attributes
    @NSManaged var userId: Int16
    @NSManaged var email: String?
    @NSManaged var emailConfirmed: Bool
    @NSManaged var newEmail: String?
    @NSManaged var newEmailConfirmed: Bool
    @NSManaged var referralCode: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
}


// MARK: - Getters & Setters
extension User {
    
    /// The url of the user's avatar. If there isn't a url, `nil` will be returned.
    var avatarUrl: URL? {
        get {
            guard let stringUrl = avatar,
                  let avatarUrl = URL(string: stringUrl) else {
                return nil
            }
            return avatarUrl
        }
        set {
            guard let url = newValue else {
                return
            }
            avatar = url.absoluteString
        }
    }
    
    /// The full name of the user.
    var fullName: String {
        let partOne: String
        if let nameFirst = firstName, !nameFirst.isEmpty {
            partOne = nameFirst
        } else {
            partOne = NSLocalizedString("User.Unidentified", comment: "default value")
        }
        let partTwo: String
        if let nameLast = lastName, !nameLast.isEmpty {
            partTwo = nameLast
        } else {
            partTwo = NSLocalizedString("User.Name", comment: "default value")
        }
        return "\(partOne) \(partTwo)"
    }
}


// MARK: - Public Class Methods
extension User {
    
    /// Gets a fetch request for all `User` entity objects.
    ///
    /// - Returns: A `NSFetchRequest<User>` representing a fetch request for all `User` objects
    @nonobjc public class func allUsersFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: User.entityName)
    }
    
    /// Gets a fetch request for a specific `User` entity object.
    ///
    /// - Parameter userId: An `Int` representing the Id of the user to retrieve.
    /// - Returns: A `NSFetchRequest<User>` encapsulating all the information needed for fetching a specific
    ///             user.
    @nonobjc public class func specificUserFetchRequest(userId: Int) -> NSFetchRequest<User> {
        let fetchRequest = NSFetchRequest<User>(entityName: User.entityName)
        fetchRequest.predicate = NSPredicate(format: "userId == %d", userId)
        return fetchRequest
    }
    
    /// Gets a fetch request for all `User` entity objects that will be sorted.
    ///
    /// - Parameters:
    ///   - keyPath: A `String` representing the key path or property name to sort by. The key path given
    ///              needs to be an existing property name of `User`.
    ///   - ascending: A `Bool` indicating if the objects needed to be in ascending order or not.
    /// - Returns: A `NSFetchRequest<User>` encapsulating all the information needed for fetching `User`
    ///            objects. If an invalid key path was given to `keyPath`, `nil` will be returned.
    @nonobjc public class func allUsersFetchRequest(keyPath: String,
                                                    ascending: Bool) -> NSFetchRequest<User>? {
        let fetchRequest = NSFetchRequest<User>(entityName: User.entityName)
        if keyPath == #keyPath(User.userId) ||
           keyPath == #keyPath(User.email) ||
           keyPath == #keyPath(User.emailConfirmed) ||
           keyPath == #keyPath(User.newEmail) ||
           keyPath == #keyPath(User.newEmailConfirmed) ||
           keyPath == #keyPath(User.referralCode) ||
           keyPath == #keyPath(User.firstName) ||
           keyPath == #keyPath(User.lastName) ||
           keyPath == #keyPath(User.avatar) {
            let sortDescriptor = NSSortDescriptor(key: keyPath, ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
            return fetchRequest
        }
        return nil
    }
}
