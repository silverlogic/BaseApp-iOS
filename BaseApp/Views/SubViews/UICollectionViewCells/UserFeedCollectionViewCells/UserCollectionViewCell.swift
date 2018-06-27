//
//  UserCollectionViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseCollectionViewCell` responsible for handling and configuring the view of a user cell.
final class UserCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var userProfileBackgroundImageView: BaseImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
}


// MARK: - Public Instance Methods
extension UserCollectionViewCell {
    
    /// Configures the view of a user cell.
    ///
    /// - Parameter name: A `String` representing the full name of the user.
    func configure(name: String) {
        userNameLabel.text = name
    }
}


// MARK: - ImageAccess
extension UserCollectionViewCell: ImageAccess {
    func setImageWithUrl(_ url: URL) {
        userProfileBackgroundImageView.setImageWithUrl(url)
    }
    
    func cancelImageDownload() {
        userProfileBackgroundImageView.cancelImageDownload()
    }
}
