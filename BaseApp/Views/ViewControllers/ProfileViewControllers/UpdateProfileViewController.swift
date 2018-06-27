//
//  UpdateProfileViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/27/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for handling intereaction from the user updating their profile.
final class UpdateProfileViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var firstNameTextField: BaseTextField!
    @IBOutlet private weak var lastNameTextField: BaseTextField!
    @IBOutlet private weak var profileImageView: BaseImageView!
    
    
    // MARK: - Public Instance Attributes
    var profileViewModel: ProfileViewModelProtocol? {
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
        if isMovingToParentViewController {
            enableKeyboardManagement(false)
        }
    }
}


// MARK: - IBActions
private extension UpdateProfileViewController {
    @IBAction func editProfileImageButtonTapped(_ sender: BaseButton) {
        showImagePicker(numberOfImages: 1) { [weak self] (images: [UIImage]) in
            guard let strongSelf = self,
                  let image = images.first else { return }
            strongSelf.profileImageView.image = image
            strongSelf.profileViewModel?.profileImage = image
        }
    }
    
    @IBAction func updateProfileButtonTapped(_ sender: BaseButton) {
        updateProfile()
    }
}


// MARK: - UITextFieldDelegate
extension UpdateProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else {
            updateProfile()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameTextField {
            profileViewModel?.firstName = textField.text!
        } else {
            profileViewModel?.lastName = textField.text!
        }
    }
}


// MARK: - Public Instance Methods
extension UpdateProfileViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
private extension UpdateProfileViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        guard let viewModel = profileViewModel else { return }
        viewModel.updateProfileError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let updateError = error else { return }
            if updateError.statusCode == 101 {
                if (strongSelf.firstNameTextField.text?.isEmpty)! {
                    strongSelf.firstNameTextField.performShakeAnimation()
                }
                if (strongSelf.lastNameTextField.text?.isEmpty)! {
                    strongSelf.lastNameTextField.performShakeAnimation()
                }
            } else {
                strongSelf.dismissProgressHudWithMessage(
                    updateError.errorDescription,
                    iconType: .error,
                    duration: nil
                )
            }
        }
        viewModel.updateProfileSuccess.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
            _ = strongSelf.navigationController?.popViewController(animated: true)
        }
        firstNameTextField.text = viewModel.firstName
        firstNameTextField.delegate = self
        lastNameTextField.text = viewModel.lastName
        lastNameTextField.delegate = self
        enableKeyboardManagement(true)
        guard let url = viewModel.avatar.value else { return }
        profileImageView.setImageWithUrl(url)
    }
    
    /// Updates the user's profile.
    func updateProfile() {
        view.endEditing(true)
        showProgresHud()
        profileViewModel?.updateProfile()
    }
}
