//
//  CaseCount+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Case Count Protocol

/// A protocol that defines count generation for an enum.
protocol CaseCount {
    static var caseCount: Int { get }
    static func numberOfCases() -> Int
}


// MARK: - CaseCount Default Implementation

/// Provides a default implementation of `numberOfCases()` when the enum type is `Int`.
extension CaseCount where Self: RawRepresentable, Self.RawValue == Int {
    static func numberOfCases() -> Int {
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        return count
    }
}
