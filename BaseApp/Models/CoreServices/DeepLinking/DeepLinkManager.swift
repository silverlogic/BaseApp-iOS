//
//  DeepLinkManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Branch
import Foundation

/// A singleton responsible for handling deep links recevied from the app delegate.
final class DeepLinkManager {
    
    // MARK: - Shared Instance
    static let shared = DeepLinkManager()
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `DeepLinkManager`.
    private init() {}
}


// MARK: - Public Instance Methods
extension DeepLinkManager {
    
    /// Initializes a BranchIO session with the launchOptions received from the app delegate's
    /// `didFinishLaunchingWithOptions` delegate method.
    ///
    /// - Parameter launchOptions: A `[UIApplicationLaunchOptionsKey: Any]?` representing the launch options
    ///                            received from the app delegate.
    func initializeBranchIOSession(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        guard let branch = Branch.getInstance() else { return }
        branch.initSession(launchOptions: launchOptions) { (params: [AnyHashable: Any]?, error: Error?) in
            if let deepLinkError = error {
                AppLogger.shared.logMessage(deepLinkError.localizedDescription, for: .error)
                return
            }
            guard let parameters = params else { return }
            AppLogger.shared.logMessage(parameters.description, for: .verbose, debugOnly: true)
            if let type = parameters["type"] as? String, type == "forgot-password" {
                guard let token = parameters["token"] as? String else { return }
                NotificationCenter.default.post(name: .PasswordReset, object: token)
                return
            }
            if let type = parameters["type"] as? String, type == "change-email-confirm" {
                guard let token = parameters["token"] as? String,
                      let userId = parameters["user"] as? Int else { return }
                NotificationCenter.default.post(name: .ChangeEmailConfirm,
                                                object: ["token": token, "userId": userId])
                return
            }
            if let type = parameters["type"] as? String, type == "change-email-verify" {
                guard let token = parameters["token"] as? String,
                      let userId = parameters["user"] as? Int else { return }
                NotificationCenter.default.post(name: .ChangeEmailVerify,
                                                object: ["token": token, "userId": userId])
                return
            }
            if let type = parameters["type"] as? String, type == "confirm-email" {
                guard let token = parameters["token"] as? String,
                      let userId = parameters["user"] as? Int else { return }
                NotificationCenter.default.post(name: .ConfirmEmail,
                                                object: ["token": token, "userId": userId])
                return
            }
        }
    }
 
    /// Responds to a URL scheme link received from the app delegate.
    ///
    /// - Parameter url: A `URL` representing the url that opened the application.
    func respondToUrlScheme(_ url: URL) {
        Branch.getInstance().handleDeepLink(url)
    }
    
    /// Responds to a universal link received from the app delegate. It takes the current state of the
    /// application and notifies BranchIO.
    ///
    /// - Parameter userActivity: A `NSUserActivity` representing the current state of the application.
    func respondToUniversalLink(userActivity: NSUserActivity) {
        Branch.getInstance().continue(userActivity)
    }
}
