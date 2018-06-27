//
//  ProfileInfoTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/23/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseTableViewCell` responsible for handling and configuring the view of the profile info of an user.
final class ProfileInfoTableViewCell: BaseTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    
    
    // MARK: - Private Instance Attributes
    private var name: DynamicBinderInterface<String>!
    private var email: DynamicBinderInterface<String>!
    
    
    // MARK: - Private Class Attributes
    private static let cellHeight: CGFloat = 129.0
    
    
    // MARK: - Public Class Methods
    override class func height() -> CGFloat {
        return cellHeight
    }
}


// MARK: - Public Instance Methods
extension ProfileInfoTableViewCell {
    
    /// Configures the view of a profile info cell.
    ///
    /// - Parameters:
    ///   - fullName: A `DynamicBinder<String>` representing the full name of the user. When changes to this
    ///               value happen, the UI updates accordingly.
    ///   - email: A `DynamicBinder<String>` representing the email of the user. When changes to this value
    ///            happen, the UI updates accordingly.
    func configure(fullName: DynamicBinderInterface<String>, email: DynamicBinderInterface<String>) {
        name = fullName
        self.email = email
        name.bind { [weak self] (name: String) in
            guard let strongSelf = self else { return }
            strongSelf.nameLabel.text = name
        }
        self.email.bind { [weak self] (email: String) in
            guard let strongSelf = self else { return }
            strongSelf.emailLabel.text = email
        }
        nameLabel.text = name.value
        emailLabel.text = self.email.value
    }
}
