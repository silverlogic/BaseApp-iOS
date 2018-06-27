//
//  SignUpViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Sign Up ViewModel Protocol

/// A protocol for defining state and behavior for signup with email.
protocol SignUpViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// The email to use for sign up.
    var email: String { get set }
    
    /// The password to use for sign up.
    var password: String { get set }
    
    /// The confirmed password to use for sign up.
    var confirmPassword: String { get set }
    
    /// The first name of the new user.
    var firstName: String { get set }
    
    /// The last name of the new user.
    var lastName: String { get set }
    
    /// Binder that gets fired when an error occured with sign up.
    var signUpError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when sign up was successful.
    var signUpSuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    
    /// Signs up the user.
    func signup()
    
    /// Validates the entered wmail.
    func validateEmail()
    
    /// Validates the entered password.
    func validatePassword()
}


// MARK: - SignUpViewModelProtocol Conformances

/// A class that conforms to `SignUpViewModelProtocol` and implements it.
private final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - SignUpViewModelProtocol Attributes
    var email: String
    var password: String
    var confirmPassword: String
    var firstName: String
    var lastName: String
    var signUpError: DynamicBinderInterface<BaseError?> {
        return signUpErrorBinder.interface
    }
    var signUpSuccess: DynamicBinderInterface<Bool> {
        return signUpSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var signUpErrorBinder: DynamicBinder<BaseError?>
    private var signUpSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: Initializers
    
    /// Initializes an instance of `SignUpViewModel`
    init() {
        email = ""
        password = ""
        confirmPassword = ""
        firstName = ""
        lastName = ""
        signUpErrorBinder = DynamicBinder(nil)
        signUpSuccessBinder = DynamicBinder(false)
    }
    
    
    // MARK: - SignUpViewModelProtocol Methods
    func signup() {
        if firstName.isEmpty || lastName.isEmpty {
            signUpErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        let signupInfo = SignUpInfo(email: email, password: password, referralCodeOfReferrer: nil)
        let updateInfo = UpdateInfo(
            referralCodeOfReferrer: nil,
            avatarBaseString: nil,
            firstName: firstName,
            lastName: lastName
        )
        AuthenticationManager.shared.signup(signupInfo, updateInfo: updateInfo, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.signUpSuccessBinder.value = true
            NotificationCenter.default.post(name: .ShowTutorial, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.signUpErrorBinder.value = error
        }
    }
    
    func validateEmail() {
        if email.isEmpty {
            signUpErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        signUpSuccessBinder.value = true
    }
    
    func validatePassword() {
        if password.isEmpty || confirmPassword.isEmpty {
            signUpErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        if password != confirmPassword {
            signUpErrorBinder.value = BaseError.passwordsDoNotMatch
            return
        }
        signUpSuccessBinder.value = true
    }
}


// MARK: - ViewModelsManager Class Extension

/// A `ViewModelsManager` class extension for `SignUpViewModelProtocol`.
extension ViewModelsManager {    
    
    /// Returns an instance conforming to `SignUpViewModelProtocol`.
    ///
    /// - Returns: an instance conforming to `SignUpViewModelProtocol`.
    class func signUpViewModel() -> SignUpViewModelProtocol {
        return SignUpViewModel()
    }
}
