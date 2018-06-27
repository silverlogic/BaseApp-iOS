//
//  BaseCollectionViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UICollectionViewCell`. It also defines and sets default attributes
/// for an instance
class BaseCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Class Attributes
    private static var size = CGSize(width: 50.0, height: 50.0)
}


// MARK: - Public Class Methods
extension BaseCollectionViewCell {
    
    /// Gets the item size of the cell.
    ///
    /// - Returns: A `CGSize` representing the size of the cell.
    open class func itemSize() -> CGSize {
        return size
    }
}
