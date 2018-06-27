//
//  Notification+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

extension Notification.Name {
    
    // MARK: - Internal Notifications
    static let UserLoggedIn = Notification.Name("UserLoggedIn")
    static let UserLoggedOut = Notification.Name("UserLoggedOut")
    static let PasswordReset = Notification.Name("PasswordReset")
    static let NotifyUserOfPasswordResetSuccess = Notification.Name("NotifyUserOfPasswordResetSuccess")
    static let ShowTutorial = Notification.Name("ShowTutorial")
    static let ChangeEmailConfirm = Notification.Name("ChangeEmailConfirm")
    static let ChangeEmailVerify = Notification.Name("ChangeEmailVerify")
    static let ConfirmEmail = Notification.Name("ConfirmEmail")
}
