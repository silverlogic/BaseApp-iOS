//
//  Array+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/22/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Public Instance Methods
extension Array {

    /// Takes an array and transforms it to a string with a given separator.
    ///
    /// - Parameter separator: A `String` representing the separator to place between each element in the
    ///                        array.
    /// - Returns: A `String` representing the elements with the given separator in between them in a textual
    ///            representation.
    func stringWithSeparator(_ separator: String) -> String {
        let stringArray = map { String(describing: $0) }
        return stringArray.joined(separator: separator)
    }
}


// MARK: - Subscript
extension Array {
    subscript (safe index: Int) -> Element? {
        return index < count && index >= 0 ? self[index] : nil
    }
}
