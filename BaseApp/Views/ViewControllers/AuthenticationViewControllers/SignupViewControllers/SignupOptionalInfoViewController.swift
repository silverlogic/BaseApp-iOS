//
//  SignupOptionalInfoViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for handling interaction from the sign up view for entering optional
/// info.
final class SignupOptionalInfoViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var firstNameTextField: BaseTextField!
    @IBOutlet private weak var lastNameTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var signUpViewModel: SignUpViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if (navigationController?.isBeingDismissed)! {
            enableKeyboardManagement(false)
        }
    }
}


// MARK: - IBAction
private extension SignupOptionalInfoViewController {
    @IBAction func signupButtonTapped(_ sender: BaseButton) {
        signupWithEmail()
    }
}


// MARK: - UITextFieldDelegate
extension SignupOptionalInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else {
            signupWithEmail()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTextField {
            signUpViewModel?.firstName = textField.text!
        } else {
            signUpViewModel?.lastName = textField.text!
        }
    }
}


// MARK: - Public Instance Methods
extension SignupOptionalInfoViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
private extension SignupOptionalInfoViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        guard let viewModel = signUpViewModel else { return }
        viewModel.signUpError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let signupError = error else { return }
            if signupError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                if (strongSelf.firstNameTextField.text?.isEmpty)! {
                    strongSelf.firstNameTextField.performShakeAnimation()
                }
                if (strongSelf.lastNameTextField.text?.isEmpty)! {
                    strongSelf.lastNameTextField.performShakeAnimation()
                }
            } else {
                strongSelf.dismissProgressHudWithMessage(signupError.errorDescription,
                                                         iconType: .error,
                                                         duration: nil)
            }
        }
        viewModel.signUpSuccess.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
        }
        firstNameTextField.text = signUpViewModel?.firstName
        lastNameTextField.text = signUpViewModel?.lastName
    }
    
    /// Signs up the user with email.
    func signupWithEmail() {
        showProgresHud()
        signUpViewModel?.signup()
    }
}
