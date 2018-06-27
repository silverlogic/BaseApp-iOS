//
//  BaseLabel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A base class for having subclasses of `UILabel`. It also defines and sets  default attributes for an
/// instance.
@IBDesignable class BaseLabel: UILabel {
    
    // MARK: - IBInspectable
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var clipToBounds: Bool = true {
        didSet {
            clipsToBounds = clipToBounds
        }
    }
    
    @IBInspectable var mainFont: UIFont = .mainRegularMedium {
        didSet {
            font = mainFont
        }
    }
}
