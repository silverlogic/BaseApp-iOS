//
//  SettingViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Setting ViewModel Protocol

/// A protocol for defining state and behavior for settings.
protocol SettingViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// Binder that gets fired when the version changes.
    var applicationVersion: DynamicBinderInterface<String> { get }
    
    /// Binder that gets fired when the invite code of the user changes.
    var inviteCode: DynamicBinderInterface<String> { get }
    
    /// Binder that gets fired when change email request fails.
    var changeEmailRequestError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when change email request was successful.
    var changeEmailRequestSuccess: DynamicBinderInterface<Bool> { get }
    
    /// List of email addresses to send feedback to.
    var sendFeedbackEmailAddresses: [String] { get }
    
    /// Subject to use for the feedback email.
    var sendFeedbackEmailSubject: String { get }
    
    /// The message body to use for the feedback email.
    var sendFeedbackEmailMessageBody: String { get }
    
    
    // MARK: - Instance Methods
    
    /// Logs out the current user.
    func logout()
    
    /// Request to change the email of the user to a new one
    ///
    /// - Parameter newEmail: A `String` representing the new email of the user.
    func changeEmailRequest(newEmail: String)
}


// MARK: - SettingViewModelProtocol Conformances

/// A class that conforms to `SettingViewModelProtocol` and implements it.
private final class SettingViewModel: SettingViewModelProtocol {
    
    // MARK: - SettingViewModelProtocol Attributes
    var applicationVersion: DynamicBinderInterface<String> {
        return applicationVersionBinder.interface
    }
    var inviteCode: DynamicBinderInterface<String> {
        return inviteCodeBinder.interface
    }
    var changeEmailRequestError: DynamicBinderInterface<BaseError?> {
        return changeEmailRequestErrorBinder.interface
    }
    var changeEmailRequestSuccess: DynamicBinderInterface<Bool> {
        return changeEmailRequestSuccessBinder.interface
    }
    var sendFeedbackEmailAddresses: [String]
    var sendFeedbackEmailSubject: String
    var sendFeedbackEmailMessageBody: String
    
    
    // MARK: - Private Instance Attributes
    private var applicationVersionBinder: DynamicBinder<String>
    private var inviteCodeBinder: DynamicBinder<String>
    private var changeEmailRequestErrorBinder: DynamicBinder<BaseError?>
    private var changeEmailRequestSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SettingViewModel`.
    init() {
        applicationVersionBinder = DynamicBinder(ConfigurationManager.shared.versionNumber)
        if let referralCode = SessionManager.shared.currentUser.value?.referralCode {
            inviteCodeBinder = DynamicBinder(referralCode)
        } else {
            inviteCodeBinder = DynamicBinder("")
        }
        changeEmailRequestErrorBinder = DynamicBinder(nil)
        changeEmailRequestSuccessBinder = DynamicBinder(false)
        sendFeedbackEmailSubject = ConfigurationManager.shared.feedbackEmailSubject
        sendFeedbackEmailAddresses = [ConfigurationManager.shared.feedbackEmailAddress]
        let messageFormatString = NSLocalizedString("Mail.MessageBody", comment: "email message")
        let displayName = ConfigurationManager.shared.displayName
        let versionNumber = ConfigurationManager.shared.versionNumber
        let userId = "\(SessionManager.shared.currentUser.value?.userId ?? 0)"
        let fullName = SessionManager.shared.currentUser.value?.fullName ?? ""
        sendFeedbackEmailMessageBody = String(
            format: messageFormatString,
            displayName,
            versionNumber,
            userId,
            fullName
        )
        SessionManager.shared.currentUser.interface.bind({ [weak self] (user: User?) in
            guard let strongSelf = self,
                  let currentUser = user,
                  let referralCode = currentUser.referralCode else { return }
            strongSelf.inviteCodeBinder.value = referralCode
            let displayName = ConfigurationManager.shared.displayName
            let versionNumber = ConfigurationManager.shared.versionNumber
            let userId = "\(currentUser.userId)"
            let fullName = currentUser.fullName
            strongSelf.sendFeedbackEmailMessageBody = String(
                format: messageFormatString,
                displayName,
                versionNumber,
                userId,
                fullName
            )
        }, for: self)
    }
    
    
    // MARK: - Deinitializers
    
    /// Deinitializes an instance of `SettingViewModel`.
    deinit {
        SessionManager.shared.currentUser.interface.unbind(for: self)
    }
    
    
    // MARK: - SettingViewModelProtocol Methods
    func logout() {
        if ProcessInfo.isRunningUnitTests { return }
        SessionManager.shared.logout()
    }
    
    func changeEmailRequest(newEmail: String) {
        if newEmail.isEmpty {
            changeEmailRequestErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.changeEmailRequest(newEmail: newEmail, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailRequestSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailRequestErrorBinder.value = error
        }
    }
}


// MARK: - ViewModelsManager Class Extension

/// A `ViewModelsManager` class extension for `SettingViewModelProtocol`.
extension ViewModelsManager {

    /// Returns an instance conforming to `SettingViewModelProtocol`.
    ///
    /// - Returns: An instance conforming to `SettingViewModelProtocol`.
    class func settingViewModel() -> SettingViewModelProtocol {
        return SettingViewModel()
    }
}
