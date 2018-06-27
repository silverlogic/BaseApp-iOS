//
//  NibLoadableView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Nib Loadable View Protocol

/// A protocol for defining how a view is loaded from a nib file.
protocol NibLoadableView: class {
    
    // MARK: - Class Attributes
    static var nibName: String { get }
    static var nibBundle: Bundle { get }
}


// MARK: - NibLoadableView Default Implementation

/// Provides a default implementation of `NibLoadableView`.
extension NibLoadableView {
    static var nibName: String {
        return String(describing: self)
    }
    
    static var nibBundle: Bundle {
        return Bundle.main
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nibBundle)
    }
}


// MARK: - UIView
extension NibLoadableView where Self: UIView {
    
    /**
        Loads a view from a nib file.
     
        - Parameters:
            - nibName: A `String` representing the name of the nib file.
            - nibBundle: A `Bundle` representing the location of the file.
     
        - Returns: A `UIView` representing the view loaded from the nib file.
    */
    static func instantiate(nibName: String = Self.nibName, nibBundle: Bundle = Self.nibBundle) -> Self {
        let array = nibBundle.loadNibNamed(nibName, owner: nil, options: nil)
        guard let view = array?.first as? Self else {
            fatalError("Nib file for class does not exist!")
        }
        return view
    }
}
