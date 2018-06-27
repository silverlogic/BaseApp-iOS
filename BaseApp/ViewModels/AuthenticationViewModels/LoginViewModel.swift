//
//  LoginViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Login ViewModel Protocol

/// A protocol for defining state and behavior for login.
protocol LoginViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    
    /// The email to use for login.
    var email: String { get set }
    
    /// The password to use for login.
    var password: String { get set }
    
    /// The redirect url to use for Facebook login.
    var facebookRedirectUri: String { get }
    
    /// The OAuth2 url for Facebook login.
    var facebookOAuthUrl: URL { get }
    
    /// The redirect url to use for Linkedin login.
    var linkedInRedirectUri: String { get }
    
    /// The OAuth2 url to use for Linkedin login.
    var linkedInOAuthUrl: URL { get }
    
    /// The redirect url to use for Twitter login.
    var twitterRedirectUri: String { get }
    
    /// The OAuth1 url to use for Twitter login.
    var twitterOAuthUrl: DynamicBinderInterface<URL?> { get }
    
    /// The redirect url with query parameters to use.
    var redirectUrlWithQueryParameters: URL? { get set }
    
    /// Binder that gets fired when an error occured with login.
    var loginError: DynamicBinderInterface<BaseError?> { get }
    
    /// Binder that gets fired when login was successful.
    var loginSuccess: DynamicBinderInterface<Bool> { get }
    
    /// Binder that gets fired when an error occured with step one of OAuth1 login.
    var oauthStep1Error: DynamicBinderInterface<BaseError?> { get }
    
    
    // MARK: - Instance Methods
    
    /// Logs in the user with an email.
    func loginWithEmail()
    
    /// Logs in the user using Facebook login.
    ///
    /// - Parameter email: A `String` representing the email of the user.
    func loginWithFacebook(email: String?)
    
    /// Logs in the user using Linkedin login.
    ///
    /// - Parameter email: A `String` representing the email of the user.
    func loginWithLinkedIn(email: String?)
    
    /// Starts the OAuth1 login process.
    func oauth1InfoForTwitter()
    
    /// Logs in the user using Twitter login.
    ///
    /// - Parameter email: A `String` representing the email of the user.
    func loginWithTwitter(email: String?)
}


// MARK: - LoginViewModelProtocol Conformances

/// A class that conforms to `LoginViewModelProtocol` and implements it.
private final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - LoginViewModelProtocol Attributes
    var email: String
    var password: String
    var facebookRedirectUri: String
    var facebookOAuthUrl: URL
    var linkedInRedirectUri: String
    var linkedInOAuthUrl: URL
    var twitterRedirectUri: String
    var twitterOAuthUrl: DynamicBinderInterface<URL?> {
        return twitterOAuthUrlBinder.interface
    }
    var redirectUrlWithQueryParameters: URL?
    var loginError: DynamicBinderInterface<BaseError?> {
        return loginErrorBinder.interface
    }
    var loginSuccess: DynamicBinderInterface<Bool> {
        return loginSuccessBinder.interface
    }
    var oauthStep1Error: DynamicBinderInterface<BaseError?> {
        return oauthStep1ErrorBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var twitterOAuth1Step1Resonse: OAuth1Step1Response?
    private var twitterOAuthUrlBinder: DynamicBinder<URL?>
    private var loginErrorBinder: DynamicBinder<BaseError?>
    private var loginSuccessBinder: DynamicBinder<Bool>
    private var oauthStep1ErrorBinder: DynamicBinder<BaseError?>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `LoginViewModel`.
    init() {
        email = ""
        password = ""
        facebookRedirectUri = ConfigurationManager.shared.facebookRedirectUri
        facebookOAuthUrl = ConfigurationManager.shared.facebookOAuthUrl!
        linkedInRedirectUri = ConfigurationManager.shared.linkedInRedirectUri
        linkedInOAuthUrl = ConfigurationManager.shared.linkedInOAuthUrl!
        twitterRedirectUri = ConfigurationManager.shared.twitterRedirectUri
        twitterOAuthUrlBinder = DynamicBinder(nil)
        redirectUrlWithQueryParameters = nil
        loginErrorBinder = DynamicBinder(nil)
        loginSuccessBinder = DynamicBinder(false)
        oauthStep1ErrorBinder = DynamicBinder(nil)
    }
}


// MARK: - LoginViewModelProtocol Methods
private extension LoginViewModel {
    func loginWithEmail() {
        if email.isEmpty || password.isEmpty {
            loginErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.login(email: email, password: password, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) {  [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.loginErrorBinder.value = error
        }
    }
    
    func loginWithFacebook(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters else {
            loginErrorBinder.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth2(redirectUrlWithQueryParameters: urlWithQueryParameters,
                                                     redirectUri: facebookRedirectUri,
                                                     provider: .facebook,
                                                     email: email,
                                                     success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginErrorBinder.value = BaseError.emailNeededForOAuthFacebook
                return
            }
            strongSelf.loginErrorBinder.value = error
        }
    }
    
    func loginWithLinkedIn(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters else {
            loginErrorBinder.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth2(redirectUrlWithQueryParameters: urlWithQueryParameters,
                                                     redirectUri: linkedInRedirectUri,
                                                     provider: .linkedIn,
                                                     email: email,
                                                     success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginErrorBinder.value = BaseError.emailNeededForOAuthLinkedIn
                return
            }
            strongSelf.loginErrorBinder.value = error
        }
    }
    
    func oauth1InfoForTwitter() {
        AuthenticationManager.shared.oauth1Step1(redirectUri: twitterRedirectUri,
                                                 provider: .twitter,
                                                 success: { [weak self] (response: OAuth1Step1Response) in
            guard let strongSelf = self else { return }
            strongSelf.twitterOAuth1Step1Resonse = response
            let escapedString = response.oauthToken.utf8
            let urlString = "https://api.twitter.com/oauth/authenticate?oauth_token=\(escapedString)"
            let twitterOAuthUrl = URL(string: urlString)
            strongSelf.twitterOAuthUrlBinder.value = twitterOAuthUrl
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.oauthStep1ErrorBinder.value = error
        }
    }
    
    func loginWithTwitter(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters,
              let oauth1Step1Resonse = twitterOAuth1Step1Resonse else {
                loginErrorBinder.value = BaseError.generic
                return
        }
        AuthenticationManager.shared.loginWithOAuth1(redirectUrlWithQueryParameters: urlWithQueryParameters,
                                                     provider: .twitter,
                                                     oauth1Response: oauth1Step1Resonse,
                                                     email: email,
                                                     success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginErrorBinder.value = BaseError.emailNeededForOAuthTwitter
                return
            }
            strongSelf.loginErrorBinder.value = error
        }
    }
}


// MARK: - ViewModelsManager Class Extension

/// A `ViewModelsManager` class extension for `LoginViewModelProtocol`.
extension ViewModelsManager {
    
    /// Returns an instance conforming to `LoginViewModelProtocol`.
    ///
    /// - Returns: an instance conforming to `LoginViewModelProtocol`.
    class func loginViewModel() -> LoginViewModelProtocol {
        return LoginViewModel()
    }
}
