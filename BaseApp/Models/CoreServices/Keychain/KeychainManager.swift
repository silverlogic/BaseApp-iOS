//
//  KeychainManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import KeychainAccess

/// A singleton responsible for interacting with Apple's Keychain API's. It uses  dependency `KeychainAccess`
/// for easier interaction.
final class KeychainManager {
    
    // MARK: - Shared Instance
    static let shared = KeychainManager()
    
    
    // MARK: - Initiailiers
    
    /// Initializes an instance of `KeychainManager`.
    private init() {}
}


// MARK: - Public Instance Methods For Insertion
extension KeychainManager {
    
    /// Inserts a string into the Keychain.
    ///
    /// - Parameters:
    ///   - item: A `String` representing the value to store in the keychain.
    ///   - key: A `String` representing the key for `item`.
    func insertItem(_ item: String, for key: String) {
        let keychain = Keychain()
        keychain[key] = item
    }
    
    /// Inserts raw binary data into the Keychain.
    ///
    /// - Parameters:
    ///   - item: A `Data` representing the value to store in the keychain.
    ///   - key: A `String` representing the key for `item`.
    func insertItem(_ item: Data, for key: String) {
        let keychain = Keychain()
        keychain[data: key] = item
    }
}


// MARK: - Public Instance Methods For Retrieval
extension KeychainManager {

    /// Retrieves a string from the Keychain.
    ///
    /// - Parameter key: A `String` representing the key to the value in the keychain.
    /// - Returns: A `String?` representing the item retrieved from the keychain. If it can't be retrieved,
    ///            `nil` will be returned.
    func stringForKey(_ key: String) -> String? {
        let keychain = Keychain()
        return keychain[key]
    }
    
    /// Retrieves raw binary data from the Keychain.
    ///
    /// - Parameter key: A `String` representing the key to the value in the keychain.
    /// - Returns: A `Data?` representing the item retrieved from the keychain. If it can't be retrieved,
    ///            `nil` will be returned.
    func dataForKey(_ key: String) -> Data? {
        let keychain = Keychain()
        return keychain[data: key]
    }
}


// MARK: - Public Instance Methods For Removal
extension KeychainManager {
    
    /// Removes an item from the Keychain.
    ///
    /// - Parameter key: A `String` representing the key to the value to remove.
    func removeItemForKey(_ key: String) {
        let keychain = Keychain()
        try? keychain.remove(key)
    }
}
