//
//  SignupEmailViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for handling interaction from the sign up view for entering an email.
final class SignupEmailViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var emailTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var signUpViewModel: SignUpViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
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


// MARK: - Navigation
extension SignupEmailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let signupPasswordViewController = segue.destination as? SignupPasswordViewController else {
            return
        }
        signupPasswordViewController.signUpViewModel = signUpViewModel!
    }
}


// MARK: - IBActions
private extension SignupEmailViewController {
    @IBAction func nextButtonTapped(_ sender: BaseButton) {
        continueSignup()
    }
}


// MARK: - UITextFieldDelegate
extension SignupEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        continueSignup()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        signUpViewModel?.email = textField.text!
    }
}


// MARK: - Public Instance Methods
extension SignupEmailViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
private extension SignupEmailViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        guard let viewModel = signUpViewModel else { return }
        viewModel.signUpError.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.emailTextField.performShakeAnimation()
        }
        viewModel.signUpSuccess.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.performSegue(withIdentifier: UIStoryboardSegue.goToSignupPasswordSegue, sender: nil)
        }
        emailTextField.text = viewModel.email
    }
    
    /// Checks if the email was filled out.
    func continueSignup() {
        view.endEditing(true)
        signUpViewModel?.validateEmail()
    }
}
