//
//  SettingsTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseTableViewCell` responsible for handling and configuring the view of a setting cell.
final class SettingsTableViewCell: BaseTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var settingsImageView: UIImageView!
    @IBOutlet private weak var settingsTypeLabel: UILabel!
    @IBOutlet private weak var settingsOptionalInfoLabel: UILabel!
    
    
    // MARK: - Private Instance Methods
    private var optionalInfo: DynamicBinderInterface<String>!
    
    
    // MARK: - Private Class Attributes
    private static let cellHeight: CGFloat = 50.0
    
    
    // MARK: - Public Class Methods
    override class func height() -> CGFloat {
        return cellHeight
    }
}


// MARK: - Public Instance Methods
extension SettingsTableViewCell {
    
    /// Configures the view of a settings cell.
    ///
    /// - Parameters:
    ///   - settingImage: A `UIImage` representing the image to use for a setting.
    ///   - settingName: A `String` representing the name of a setting.
    ///   - optionalInfo: A `DynamicBinder<String>` representing optional info to display on the right side
    ///                   of the cell. It could be the invite code of the current user or the version of the
    ///                   app. When changes to this value happen, the UI updates accordingly.
    func configure(settingImage: UIImage, settingName: String, optionalInfo: DynamicBinderInterface<String>) {
        settingsImageView.image = settingImage
        settingsTypeLabel.text = settingName
        settingsOptionalInfoLabel.text = optionalInfo.value
        self.optionalInfo = optionalInfo
        self.optionalInfo.bind { [weak self] (info: String) in
            guard let strongSelf = self else { return }
            strongSelf.settingsOptionalInfoLabel.text = info
        }
    }
}
