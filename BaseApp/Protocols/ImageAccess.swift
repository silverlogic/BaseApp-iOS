//
//  ImageAccess.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/23/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A protocol for defining how `UIImageView` can be accessed from outside a view when needing to set the
/// image with a `URL`. It defines the encapsulation of the image view. This would be used in an
/// `UITableViewCell` or an `UICollectionViewCell` that has a image view but you don't want to expose the
/// component.
protocol ImageAccess {
    
    // MARK: - Public Instance Methods
    func setImageWithUrl(_ url: URL)
    func cancelImageDownload()
}
