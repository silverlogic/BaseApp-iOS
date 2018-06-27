//
//  BaseTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UITableViewCell`. It also defines and sets default attributes for
/// an instance.
class BaseTableViewCell: UITableViewCell {
    
    // MARK: - Private Class Attributes
    fileprivate static var cellHeight: CGFloat = 44.0
    
    
    // MARK: - Public Class Methods
    
    /// Gets the height of the cell.
    ///
    /// - Returns: A `CGFloat` representing the height of the cell.
    open class func height() -> CGFloat {
        return cellHeight
    }
}
