//
//  ProfileImageTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/23/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseTableViewCell` responsible for handling and configuring the view of a profile image of an user.
final class ProfileImageTableViewCell: BaseTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var profileImageView: CircleImageView!
    
    
    // MARK: - Private Class Attributes
    private static let cellHeight: CGFloat = 209.0
    
    
    // MARK: - Public Class Methods
    override class func height() -> CGFloat {
        return cellHeight
    }
}


// MARK: - ImageAccess
extension ProfileImageTableViewCell: ImageAccess {
    func setImageWithUrl(_ url: URL) {
        profileImageView.setImageWithUrl(url)
    }
    
    func cancelImageDownload() {
        profileImageView.cancelImageDownload()
    }
}
