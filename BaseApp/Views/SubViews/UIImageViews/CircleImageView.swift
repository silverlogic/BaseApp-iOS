//
//  CircleImageView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit

/// A subclass of `BaseImageView`. It makes an instance a perfect circle.
@IBDesignable class CircleImageView: BaseImageView {
    
    // MARK: - Lifcycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }
}


// MARK: - Private Instance Methods
fileprivate extension CircleImageView {
    
    /// Configures the view to be a circle.
    fileprivate func setup() {
        layer.cornerRadius = frame.size.width / 2
        clipToBounds = true
    }
}
