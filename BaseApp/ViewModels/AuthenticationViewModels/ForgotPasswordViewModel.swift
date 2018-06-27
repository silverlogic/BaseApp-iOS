//
//  ForgotPasswordViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Forgot Password ViewModel Protocol

/// A protocol for defining state and behavior for forgot password.
protocol ForgotPasswordViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// The email to send a link for reseting the password.
    var email: String { get set }
    
    /// The new password to use.
    var newPassword: String { get set }
    
    /// Binder that gets fired when an error occured with forgot password.
    var forgotPasswordError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when request new password was succesful.
    var forgotPasswordRequestSuccess: DynamicBinderInterface<Bool> { get }
    
    /// Binder that gets fired when reseting the password was successful.
    var forgotPasswordResetSuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    
    /// Requests to reset the password.
    func forgotPasswordRequest()
    
    /// Resets the password.
    func forgotPasswordReset()
    
    /// Cancels reseting the password.
    func cancelResetPassword()
}


// MARK: - ForgotPasswordViewModelProtocol Conformances

/// A class that conforms to `ForgotPasswordViewModelProtocol` and implements it.
private final class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    
    // MARK: - ForgotPasswordViewModelProtocol Attributes
    var email: String
    var newPassword: String
    var forgotPasswordError: DynamicBinderInterface<BaseError?> {
        return forgotPasswordErrorBinder.interface
    }
    var forgotPasswordRequestSuccess: DynamicBinderInterface<Bool> {
        return forgotPasswordRequestSuccessBinder.interface
    }
    var forgotPasswordResetSuccess: DynamicBinderInterface<Bool> {
        return forgotPasswordResetSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Methods
    private var token: String?
    private var forgotPasswordErrorBinder: DynamicBinder<BaseError?>
    private var forgotPasswordRequestSuccessBinder: DynamicBinder<Bool>
    private var forgotPasswordResetSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `ForgotPasswordViewModel`.
    ///
    /// - Parameter token: A `String` representing the verification token received from a forgot password
    ///                    deep link. `nil` can be passed as a parameter.
    init(token: String?) {
        email = ""
        newPassword = ""
        forgotPasswordErrorBinder = DynamicBinder(nil)
        forgotPasswordRequestSuccessBinder = DynamicBinder(false)
        forgotPasswordResetSuccessBinder = DynamicBinder(false)
        self.token = token
    }
    
    
    // MARK: - ForgotPasswordViewModelProtocol Methods
    func forgotPasswordRequest() {
        if email.isEmpty {
            forgotPasswordErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.forgotPasswordRequest(email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordRequestSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordErrorBinder.value = error
        }
    }
    
    func forgotPasswordReset() {
        guard let verificationToken = token else { return }
        if newPassword.isEmpty {
            forgotPasswordErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.forgotPasswordReset(token: verificationToken,
                                                         newPassword: newPassword,
                                                         success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordResetSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordErrorBinder.value = error
        }
    }
    
    func cancelResetPassword() {
        if ProcessInfo.isRunningUnitTests { return }
        NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
    }
}


// MARK: - ViewModelsManager Class Extension

/// A `ViewModelsManager` class extension for `ForgotPasswordViewModelProtocol`.
extension ViewModelsManager {    
    
    /// Returns an instance conforming to `ForgotPasswordViewModelProtocol`.
    ///
    /// - Parameter token: A `String` representing the verification token received from a forgot password deep
    ///                    link. `nil` can be passed as a parameter.
    /// - Returns: an instance conforming to `ForgotPasswordViewModelProtocol`.
    class func forgotPasswordViewModel(token: String?) -> ForgotPasswordViewModelProtocol {
        return ForgotPasswordViewModel(token: token)
    }
}
