//
//  ChangePasswordViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/11/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for handling interaction from the change password view.
final class ChangePasswordViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var currentPasswordTextField: BaseTextField!
    @IBOutlet private weak var newPasswordTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var changePasswordViewModel: ChangePasswordViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        enableKeyboardManagement(false)
    }
}


// MARK: - IBActions
private extension ChangePasswordViewController {
    @IBAction func changePasswordButtonTapped(_ sender: BaseButton) {
        changePassword()
    }
}


// MARK: - UITextFieldDelegate
extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == currentPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else {
            changePassword()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == currentPasswordTextField {
            changePasswordViewModel?.currentPassword = textField.text!
        } else {
            changePasswordViewModel?.newPassword = textField.text!
        }
    }
}


// MARK: - Public Instance Methods
extension ChangePasswordViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
private extension ChangePasswordViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        guard let viewModel = changePasswordViewModel else { return }
        viewModel.changePasswordError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let changePasswordError = error else { return }
            if changePasswordError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                if (strongSelf.currentPasswordTextField.text?.isEmpty)! {
                    strongSelf.currentPasswordTextField.performShakeAnimation()
                }
                if (strongSelf.newPasswordTextField.text?.isEmpty)! {
                    strongSelf.newPasswordTextField.performShakeAnimation()
                }
            } else {
                strongSelf.dismissProgressHudWithMessage(
                    changePasswordError.errorDescription,
                    iconType: .error,
                    duration: nil
                )
            }
        }
        viewModel.changePasswordSuccess.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
            _ = strongSelf.navigationController?.popViewController(animated: true)
        }
        currentPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    /// Changes the password of the current user.
    func changePassword() {
        view.endEditing(true)
        showProgresHud()
        changePasswordViewModel?.changePassword()
    }
}
