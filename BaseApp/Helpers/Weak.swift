//
//  Weak.swift
//  BaseAppV2
//
//  Created by Vasilii Muravev on 5/1/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

/// Generic struct for storing weak references.
struct Weak<T: AnyObject> {
    
    // MARK: - Public Instance Attributes
    fileprivate(set) weak var value: T?
    
    
    // MARK: - Initializers
    
    /// Initializes a struct of `Weak`.
    ///
    /// - Parameter value: A `T` representing the value reference which should be stored as weak.
    init(_ value: T) {
        self.value = value
    }
    
    /// Unavailable initializer, use `init(_ value: T)` instead.
    @available(*, unavailable)
    init() {
        fatalError("unavailable initializer")
    }
}
