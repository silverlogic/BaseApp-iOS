//
//  CircleView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/27/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A subclass of `BaseView`. It makes an instance a perfect cicle.
@IBDesignable class CircleView: BaseView {
    
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
fileprivate extension CircleView {
    
    /// Configures the view to be a circle.
    fileprivate func setup() {
        layer.cornerRadius = frame.size.width / 2
        clipToBounds = true
    }
}
