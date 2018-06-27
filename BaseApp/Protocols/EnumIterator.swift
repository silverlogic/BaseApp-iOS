//
//  EnumIterator.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 1/2/18.
//  Copyright © 2018 SilverLogic. All rights reserved.
//

import Foundation

/// A protocol that defines how an enum can be iterated over.
protocol EnumIterator: Hashable {
    
    /// Retrieves all registered cases in the enum and returns them as a sequence that can be iterated.
    ///
    /// - Returns: An `AnySequence<Self>` representing the sequence of all the registered cases.
    static func cases() -> AnySequence<Self>
    
    /// Retrieves the next case in the enum.
    ///
    /// For example here we have an enum called Move that conforms to `EnumIterator`:
    /// ```
    /// enum Move: EnumIterator {
    ///     case up
    ///     case down
    ///     case left
    ///     case right
    /// }
    /// ```
    ///
    /// Now lets declare instance of `Move`:
    /// ```
    /// var move = Move.up
    /// ```
    ///
    /// `move` is set to `Move.up`. Now we want to find out what the next case based on the current case set
    ///  for `move`. We can do that like this:
    /// ```
    /// move = Moves.caseAfter(move)!
    /// print(move)
    /// ```
    ///
    /// This will print down. So now move is set to `Move.down`. We can kepp calling this to get the next
    /// case. But what happens if `move` is set to the last case of the enum? Then the next case will be the
    /// the first case of the enum:
    /// ```
    /// var move = Move.right
    /// move = Move.nextCase(move)
    /// // This will print up
    /// print(move)
    /// ```
    ///
    /// - Parameter currentCase: A `Self` representing the case type of an enum.
    /// - Returns: A `Self?` representing the next possible case in the enum.
    static func caseAfter(_ currentCase: Self) -> Self?
    
    /// Retrieves the previous case in the enum.
    ///
    /// For example here we have an enum called Move that conforms to `EnumIterator`:
    /// ```
    /// enum Move: EnumIterator {
    ///     case up
    ///     case down
    ///     case left
    ///     case right
    /// }
    /// ```
    ///
    /// Now lets declare instance of `Move`:
    /// ```
    /// var move = Move.down
    /// ```
    ///
    /// `move` is set to `Move.down`. Now we want to find out what the previous case based on the current case
    ///  set for `move`. We can do that like this:
    /// ```
    /// move = Moves.caseBefore(move)!
    /// print(move)
    /// ```
    ///
    /// This will print up. So now move is set to `Move.up`. We can kepp calling this to get the next
    /// case. But what happens if `move` is set to the first case of the enum? Then the next case will be the
    /// the last case of the enum:
    /// ```
    /// var move = Move.up
    /// move = Move.beforeCase(move)
    /// // This will print right
    /// print(move)
    /// ```
    ///
    /// - Parameter currentCase: A `Self` representing the case type of an enum.
    /// - Returns: A `Self?` representing the previous possible case in the enum.
    static func caseBefore(_ currentCase: Self) -> Self?
}


// MARK: - Default Implementations
extension EnumIterator {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var rawPointer = 0
            return AnyIterator {
                let currentCase: Self = withUnsafePointer(to: &rawPointer) {
                    $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee }
                }
                guard currentCase.hashValue == rawPointer else { return nil }
                rawPointer += 1
                return currentCase
            }
        }
    }
    
    static func caseAfter(_ currentCase: Self) -> Self? {
        let allCases = Array(Self.cases())
        guard let currentCaseIndex = allCases.index(of: currentCase) else { return nil }
        let nextCaseIndex = allCases.index(after: currentCaseIndex)
        guard let nextCase = allCases[safe: nextCaseIndex] else {
            return allCases.first
        }
        return nextCase
    }
    
    static func caseBefore(_ currentCase: Self) -> Self? {
        let allCases = Array(Self.cases())
        guard let currentCaseIndex = allCases.index(of: currentCase) else { return nil }
        let previousCaseIndex = allCases.index(before: currentCaseIndex)
        guard let previousCase = allCases[safe: previousCaseIndex] else {
            return allCases.last
        }
        return previousCase
    }
}
