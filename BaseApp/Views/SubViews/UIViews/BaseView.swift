//
//  BaseView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit

/// A base class for having subclasses of `UIView`. It also defines and sets default attributes for an
/// instance.
@IBDesignable class BaseView: UIView {
    
    // MARK: - Lifecycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
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
    
    @IBInspectable var colorBackground: UIColor = .main {
        didSet {
            backgroundColor = colorBackground
        }
    }
}
