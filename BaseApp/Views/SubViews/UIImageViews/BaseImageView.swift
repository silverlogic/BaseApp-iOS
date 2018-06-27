//
//  BaseImageView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Kingfisher
import UIKit

/// A base class for having subclasses of `UIImageView`. It also defines and sets default attributes for an
/// instance.
@IBDesignable class BaseImageView: UIImageView {
    
    // MARK: - Lifecycle
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    // MARK: - IBInspectable
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var clipToBounds: Bool = true {
        didSet {
            clipsToBounds = clipToBounds
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3.0, height: 3.0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.7 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.2 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
}


// MARK: - Kingfisher
extension BaseImageView {
    
    /// Sets the image of the view with a given url.
    ///
    /// - Parameter url: A `URL` representing the path of the image resource.
    public func setImageWithUrl(_ url: URL) {
        let options = [KingfisherOptionsInfoItem.transition(ImageTransition.fade(1))]
        kf.setImage(with: url,
                    placeholder: #imageLiteral(resourceName: "icon-imageplaceholder-blue"),
                    options: options, progressBlock: nil) { [weak self] (image: Image?, _, _, _) in
            guard let strongSelf = self,
                  let downloadedImage = image else { return }
            strongSelf.image = downloadedImage
            strongSelf.contentMode = .scaleAspectFill
        }
    }
    
    /// Cancels downloading the image from the url.
    public func cancelImageDownload() {
        kf.cancelDownloadTask()
    }
}
