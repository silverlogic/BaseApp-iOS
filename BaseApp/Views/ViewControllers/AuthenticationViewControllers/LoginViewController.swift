//
//  LoginViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A `BaseViewController` responsible for handling interaction from the login view.
final class LoginViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var emailTextField: BaseTextField!
    @IBOutlet private weak var passwordTextField: BaseTextField!
    
    
    // MARK: - Public Instance Attributes
    var loginViewModel: LoginViewModelProtocol? {
        didSet {
            setup()
        }
    }
    
    
    // MARK: - Private Instance Attributes
    private enum LoginButtons: Int, CaseCount {
        case login
        case facebook
        case twitter
        case createAccount
        case forgotPassword
        static let caseCount = LoginButtons.numberOfCases()
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segue.identifier else { return }
        if segueIdentifier == UIStoryboardSegue.goToSignupEmailSegue {
            guard let signupEmailViewController = segue.destination as? SignupEmailViewController else {
                return
            }
            signupEmailViewController.signUpViewModel = ViewModelsManager.signUpViewModel()
        } else {
            guard let forgotViewController = segue.destination as? ForgotPasswordRequestViewController else {
                return
            }
            forgotViewController.forgotPasswordViewModel = ViewModelsManager
                                                           .forgotPasswordViewModel(token: nil)
        }
    }
}


// MARK: - IBActions
private extension LoginViewController {
    @IBAction func baseButtonTapped(_ sender: BaseButton) {
        guard let tag = LoginButtons(rawValue: sender.tag) else { return }
        switch tag {
        case .login:
            loginWithEmail()
        case .facebook:
            let redirectUrl = (loginViewModel?.facebookRedirectUri)!
            let oauthUrl = (loginViewModel?.facebookOAuthUrl)!
            let socialAuthWebViewController = SocialAuthWebViewController(
                redirectUri: redirectUrl,
                oauthUrl: oauthUrl
            )
            let handler: ((_ redirectUrl: URL) -> Void) = { [weak self] (redirectUrlWithQueryParameters) in
                guard let strongSelf = self else { return }
                strongSelf.loginViewModel?.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
                strongSelf.showProgresHud()
                strongSelf.loginViewModel?.loginWithFacebook(email: nil)
            }
            socialAuthWebViewController.redirectUrlWithQueryParametersRecieved = handler
            let controller = BaseNavigationController(rootViewController: socialAuthWebViewController)
            present(controller, animated: true, completion: nil)
        case .twitter:
            showProgresHud()
            loginViewModel?.oauth1InfoForTwitter()
        case .createAccount:
            performSegue(withIdentifier: UIStoryboardSegue.goToSignupEmailSegue, sender: nil)
        case .forgotPassword:
            performSegue(withIdentifier: UIStoryboardSegue.goToForgotPasswordRequestSegue, sender: nil)
        }
    }
}


// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            loginWithEmail()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            loginViewModel?.email = textField.text!
        } else {
            loginViewModel?.password = textField.text!
        }
    }
}


// MARK: - Public Instance Methods
extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - Private Instance Methods
private extension LoginViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        guard let viewModel = loginViewModel else { return }
        viewModel.loginError.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let loginError = error else { return }
            if loginError.statusCode == 101 {
                strongSelf.dismissProgressHud()
                if (strongSelf.emailTextField.text?.isEmpty)! {
                    strongSelf.emailTextField.performShakeAnimation()
                }
                if (strongSelf.passwordTextField.text?.isEmpty)! {
                    strongSelf.passwordTextField.performShakeAnimation()
                }
            } else if loginError.statusCode == 105 {
                strongSelf.dismissProgressHud()
                let title = NSLocalizedString("Miscellaneous.EmailMissing", comment: "alert title")
                let placeholder = NSLocalizedString("Miscellaneous.Email", comment: "placeholder")
                let textFieldAttribute = AlertTextFieldAttributes(
                    placeholder: placeholder,
                    isSecureTextEntry: false,
                    keyboardType: .emailAddress,
                    autocorrectionType: .no,
                    autocapitalizationType: .none,
                    spellCheckingType: .no,
                    returnKeyType: .done
                )
                let textFieldAttributes = [textFieldAttribute]
                strongSelf.showEditAlert(title: title,
                                         subtitle: loginError.errorDescription,
                                         textFieldAttributes: textFieldAttributes,
                                         submitButtonTapped: { [weak self] (enteredValues) in
                    guard let strongSelf = self else { return }
                    let email = enteredValues[NSLocalizedString("Miscellaneous.Email", comment: "title")]
                    strongSelf.showProgresHud()
                    viewModel.loginWithFacebook(email: email)
                })
            } else if loginError.statusCode == 107 {
                strongSelf.dismissProgressHud()
                let title = NSLocalizedString("Miscellaneous.EmailMissing", comment: "alert title")
                let placeholder = NSLocalizedString("Miscellaneous.Email", comment: "placeholder")
                let textFieldAttribute = AlertTextFieldAttributes(
                    placeholder: placeholder,
                    isSecureTextEntry: false,
                    keyboardType: .emailAddress,
                    autocorrectionType: .no,
                    autocapitalizationType: .none,
                    spellCheckingType: .no,
                    returnKeyType: .done
                )
                let textFieldAttributes = [textFieldAttribute]
                strongSelf.showEditAlert(title: title,
                                         subtitle: loginError.errorDescription,
                                         textFieldAttributes: textFieldAttributes,
                                         submitButtonTapped: { [weak self] (enteredValues) in
                    guard let strongSelf = self else { return }
                    let email = enteredValues[NSLocalizedString("Miscellaneous.Email", comment: "title")]
                    strongSelf.showProgresHud()
                    viewModel.loginWithTwitter(email: email)
                })
            } else {
                strongSelf.dismissProgressHudWithMessage(
                    loginError.errorDescription,
                    iconType: .error,
                    duration: nil
                )
            }
        }
        viewModel.loginSuccess.bind { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.dismissProgressHud()
        }
        viewModel.oauthStep1Error.bind { [weak self] (error: BaseError?) in
            guard let strongSelf = self,
                  let step1Error = error else { return }
            strongSelf.dismissProgressHudWithMessage(
                step1Error.errorDescription,
                iconType: .error,
                duration: nil
            )
        }
        viewModel.twitterOAuthUrl.bind { [weak self] (url: URL?) in
            guard let strongSelf = self,
                  let oauthUrl = url else { return }
            strongSelf.dismissProgressHud()
            let redirectUrl = viewModel.twitterRedirectUri
            let socialAuthWebViewController = SocialAuthWebViewController(
                redirectUri: redirectUrl,
                oauthUrl: oauthUrl
            )
            let handler: ((_ redirectUrl: URL) -> Void) = { [weak self] (redirectUrlWithQueryParameters) in
                guard let strongSelf = self else { return }
                viewModel.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
                strongSelf.showProgresHud()
                viewModel.loginWithTwitter(email: nil)
            }
            socialAuthWebViewController.redirectUrlWithQueryParametersRecieved = handler
            let controller = BaseNavigationController(rootViewController: socialAuthWebViewController)
            strongSelf.present(controller, animated: true, completion: nil)
        }
        emailTextField.delegate = self
        passwordTextField.delegate = self
        enableKeyboardManagement(true)
    }
    
    /// Logs in the user with email.
    func loginWithEmail() {
        view.endEditing(true)
        showProgresHud()
        loginViewModel?.loginWithEmail()
    }
}
