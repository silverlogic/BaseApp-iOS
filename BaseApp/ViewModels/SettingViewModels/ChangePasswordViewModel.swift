//
//  ChangePasswordViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Change Password ViewModel Protocol

/// A protocol for defining state and behavior for changing a password.
protocol ChangePasswordViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// The current password of the user.
    var currentPassword: String { get set }
    
    /// The new password of the user.
    var newPassword: String { get set }
    
    /// Binder that gets fired when an error occured with changing the password.
    var changePasswordError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when changing the password was successful.
    var changePasswordSuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    
    /// Changes the password of the current user.
    func changePassword()
}


// MARK: - ChangePasswordViewModelProtocol Conformances

/// A class that conforms to `ChangePasswordViewModelProtocol` and implements it.
private final class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    
    // MARK: - ChangePasswordViewModelProtocol Attributes
    var currentPassword: String
    var newPassword: String
    var changePasswordError: DynamicBinderInterface<BaseError?> {
        return changePasswordErrorBinder.interface
    }
    var changePasswordSuccess: DynamicBinderInterface<Bool> {
        return changePasswordSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var changePasswordErrorBinder: DynamicBinder<BaseError?>
    private var changePasswordSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `ChangePasswordViewModel`.
    init() {
        currentPassword = ""
        newPassword = ""
        changePasswordErrorBinder = DynamicBinder(nil)
        changePasswordSuccessBinder = DynamicBinder(false)
    }
    
    
    // MARK: - ChangePasswordViewModelProtocol Methods
    func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty {
            changePasswordErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.changePassword(currentPassword: currentPassword,
                                                    newPassword: newPassword,
                                                    success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changePasswordSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changePasswordErrorBinder.value = error
        }
    }
}


// MARK: - ViewModelsManager Class Extension

/// A `ViewModelsManager` class extension for `ChangePasswordViewModelProtocol`.
extension ViewModelsManager {
    
    /// Returns an instance conforming to `ChangePasswordViewModelProtocol`.
    ///
    /// - Returns: an instance conforming to `ChangePasswordViewModelProtocol`.
    class func changePasswordViewModel() -> ChangePasswordViewModelProtocol {
        return ChangePasswordViewModel()
    }
}
