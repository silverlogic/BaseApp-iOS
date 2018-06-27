//
//  String+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/21/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Public Instance Methods
extension String {

    /// Truncates a `String` to the length of number of characters and appends optional trailing string if
    /// longer.
    ///
    /// - Parameter length: An `Int` representing the number of characters before truncation.
    /// - Returns: A `String` representing a truncated sentence or word depending on character length.
    func truncate(length: Int) -> String {
        if self.count > length {
            let index = self.index(self.startIndex, offsetBy: length)
            let subString = self[..<index]
            return subString.appending(" ...")
        } else {
            return self
        }
    }
}


// MARK: - Public Class Methods
extension String {

    /// Generates a random string to prevent cross-site request forgery. Required for Linkedin OAuth.
    ///
    /// - Parameter length: A `Int` representing how long the string should be.
    /// - Returns: A `String` representing the random state.
    static func randomStateString(_ length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var randomString = ""
        for _ in 0..<length {
            let randomNumber = arc4random_uniform(len)
            let index = letters.index(letters.startIndex, offsetBy: Int(randomNumber))
            let letter = letters[index]
            randomString += String(letter)
        }
        return randomString
    }
}
