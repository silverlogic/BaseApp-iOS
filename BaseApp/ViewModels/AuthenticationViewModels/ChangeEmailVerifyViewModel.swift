//
//  ChangeEmailVerifyViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - CHange Email Verify ViewModel Protocol

/// A protocol for defining state and behavior for change email verify.
protocol ChangeEmailVerifyViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// Binder that gets fired when an error occurs with verifying the changed email.
    var changeEmailVerifyError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when verifying the changed email was successful.
    var changeEmailVerifySuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    
    /// Verify the changed email.
    func changeEmailVerify()
    
    /// Cancel verifying the changed email.
    func cancelChangeEmail()
}


// MARK: - ChangeEmailVerifyViewModelProtocol Conformances

/// A class that conforms to `ChangeEmailVerifyViewModelProtocol` and implements it.
private final class ChangeEmailVerifyViewModel: ChangeEmailVerifyViewModelProtocol {
    
    // MARK: - ChangeEmailVerifyViewModelProtocol Attributes
    var changeEmailVerifyError: DynamicBinderInterface<BaseError?> {
        return changeEmailVerifyErrorBinder.interface
    }
    var changeEmailVerifySuccess: DynamicBinderInterface<Bool> {
        return changeEmailVerifySuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private let token: String
    private let userId: Int
    private var changeEmailVerifyErrorBinder: DynamicBinder<BaseError?>
    private var changeEmailVerifySuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `ChangeEmailVerifyViewModel`.
    ///
    /// - Parameters:
    ///   - token: A `String` representing the token received from change email confirm deep link.
    ///   - userId: A `Int` representing the user that changed their email from change email confirm deep
    ///             link.
    init(token: String, userId: Int) {
        changeEmailVerifyErrorBinder = DynamicBinder(nil)
        changeEmailVerifySuccessBinder = DynamicBinder(false)
        self.token = token
        self.userId = userId
    }
    
    
    // MARK: - ChangeEmailVerifyViewModelProtocol Methods
    func changeEmailVerify() {
        AuthenticationManager.shared.changeEmailVerify(token: token, userId: userId, success: { [weak self] in
            guard let strongSelf = self else { return }
            if SessionManager.shared.authorizationToken == nil {
                strongSelf.changeEmailVerifySuccessBinder.value = true
                NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
                return
            }
            AuthenticationManager.shared.currentUser(success: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.changeEmailVerifySuccessBinder.value = true
                NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
            }, failure: { [weak self] (error: BaseError) in
                guard let strongSelf = self else { return }
                strongSelf.changeEmailVerifyErrorBinder.value = error
            })
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailVerifyErrorBinder.value = error
        }
    }
    
    func cancelChangeEmail() {
        guard SessionManager.shared.authorizationToken != nil else {
            NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
            return
        }
        NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
    }
}


// MARK: - ViewModelsManager Class Extension

/// A `ViewModelsManager` class extension for `ChangeEmailVerifyViewModelProtocol`.
extension ViewModelsManager {
    
    /// Returns an instance conforming to `ChangeEmailVerifyViewModelProtocol`.
    ///
    /// - Parameters:
    ///   - token: A `String` representing the token received from change email confirm deep link.
    ///   - userId: A `Int` representing the user that changed their email from change email confirm deep
    ///             link.
    /// - Returns: an instance conforming to `ChangeEmailVerifyViewModelProtocol`.
    class func changeEmailVerifyViewModel(token: String, userId: Int) -> ChangeEmailVerifyViewModelProtocol {
        return ChangeEmailVerifyViewModel(token: token, userId: userId)
    }
}
