//
//  AuthenticationManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A singleton responsible for login, signup, social authentication, forgot password and change password
/// operations.
final class AuthenticationManager {
    
    // MARK: - Shared Instance
    static let shared = AuthenticationManager()
    
    
    // MARK: - Initializers
    
    /// Initializes a shared instance of `AuthenticationManager`.
    private init() {}
}


// MARK: - Public Instance Methods
extension AuthenticationManager {
    
    /// Logs in a user with a given email and password.
    ///
    /// - Parameters:
    ///   - email:  A `String` representing the email of the user.
    ///   - password: A `String` representing the password of the user.
    ///   - success: A closure that gets invoked when logging in a user was successful.
    ///   - failure: A closure that gets invoked when logging in a user failed. Passes a `BaseError` object
    ///              that contains the error that occured.
    func login(email: String,
               password: String,
               success: @escaping () -> Void,
               failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.login(email: email, password: password))
            .then(on: dispatchQueue) { (loginResponse: LoginResponse) in
                SessionManager.shared.authorizationToken = loginResponse.token
                return networkClient.enqueue(AuthenticationEndpoint.currentUser)
            }
            .then(on: dispatchQueue) { (user: User) -> Void in
                SessionManager.shared.currentUser = MultiDynamicBinder(user)
            }
            .then(on: DispatchQueue.main) {
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Signs up a new user.
    ///
    /// - Parameters:
    ///   - signupInfo: A `SignUpInfo` representing the information needed for signup.
    ///   - updateInfo: A `UpdateInfo` representing the information needed for updating the user once they
    ///                 have logged in and received an authorization token.
    ///   - success: A closure that gets invoked when signing up the user was successful.
    ///   - failure: A closure that gets invoked when signing up the user failed. Passes a `BaseError` object
    ///              that contains the error that occured.
    func signup(_ signupInfo: SignUpInfo,
                updateInfo: UpdateInfo,
                success: @escaping () -> Void,
                failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.signUp(signUpInfo: signupInfo))
            .then(on: dispatchQueue) { (user: User) in
                SessionManager.shared.currentUser.value = user
                let endpoint = AuthenticationEndpoint.login(
                    email: signupInfo.email,
                    password: signupInfo.password
                )
                return networkClient.enqueue(endpoint)
            }
            .then(on: dispatchQueue) { (loginResponse: LoginResponse) in
                SessionManager.shared.authorizationToken = loginResponse.token
                let userId = Int((SessionManager.shared.currentUser.value?.userId)!)
                let endpoint = AuthenticationEndpoint.update(
                    updateInfo: updateInfo,
                    userId: userId
                )
                return networkClient.enqueue(endpoint)
            }
            .then(on: DispatchQueue.main) { (user: User) -> Void in
                SessionManager.shared.currentUser = MultiDynamicBinder(user)
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Gets the current user.
    ///
    /// - Parameters:
    ///   - success: A closure that gets invoked when getting the current user was successful.
    ///   - failure: A closure that gets invoked when getting the current user failed. Passes a `BaseError`
    ///              object containing the error that occured.
    func currentUser(success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.currentUser)
            .then(on: DispatchQueue.main) { (user: User) -> Void in
                SessionManager.shared.currentUser.value = user
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Logs in a user using OAuth2 authentication.
    ///
    /// ## Possible Errors
    ///
    /// 1. When an email wasn't provided when logging into the provider or the provider doesn't give an email
    ///    for the user, the user would be asked to provide an email. Then recall this method with the
    ///    provided email.
    /// 2. When an email given from the provider is already in use in the API, login can't continue and the
    ///    user should be notified.
    /// 3. When an invalid provider is given or the OAuth authorization code is incorrect, the user should be
    ///    notified. This can occur if the token expired or the registered app id and/or redirect url used
    ///    isn't the same as the one the API used.
    /// 4. If the OAuth authorization code can't be parsed, the user should  be notified.
    ///
    /// - Parameters:
    ///   - redirectUrlWithQueryParameters: A `URL` representing the redirect url that the OAuth2 provider
    ///                                     used. This would contain the OAuth authorization code in it as a
    ///                                     query parameter.
    ///   - redirectUri:  A `String` representing the redirect uri registered for the provider.
    ///   - provider: An `OAuth2Provider` representing the type of provider used. This determines how
    ///               `redirectUrlWithQueryParameters` would be parsed.
    ///   - email: A `String` representing the email of the user. This would be filled if an email wasn't
    ///            provided to the provider. `nil` can be passed as a parameter.
    ///   - success: A closure that gets invoked when logging in the user was successful.
    ///   - failure: A closure that gets invoked when logging in the user failed. Passes an `BaseError` object
    ///              that contains the error that occured.
    func loginWithOAuth2(redirectUrlWithQueryParameters: URL,
                         redirectUri: String,
                         provider: OAuth2Provider,
                         email: String?,
                         success: @escaping () -> Void,
                         failure: @escaping (_ error: BaseError) -> Void) {
        let absoluteString = redirectUrlWithQueryParameters.absoluteString
        guard let range = absoluteString.range(of: "code=") else {
            failure(BaseError.generic)
            return
        }
        var newRange = range.upperBound
        var code = String(absoluteString[newRange...])
        if provider == .linkedIn {
            guard let linkedInRange = code.range(of: "&state=") else {
                failure(BaseError.generic)
                return
            }
            newRange = linkedInRange.lowerBound
            code = String(code[...newRange])
        }
        let oauth2Info = OAuth2Info(
            provider: provider,
            oauthCode: code,
            redirectUri: redirectUri,
            email: email,
            referralCodeOfReferrer: nil
        )
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.oauth2(oauth2Info: oauth2Info))
            .then(on: dispatchQueue) { (oauthResponse: OAuthResponse) in
                SessionManager.shared.authorizationToken = oauthResponse.token
                return networkClient.enqueue(AuthenticationEndpoint.currentUser)
            }
            .then(on: DispatchQueue.main) { (user: User) -> Void in
                SessionManager.shared.currentUser = MultiDynamicBinder(user)
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                if error.errorDescription == OAuthErrorConstants.noEmailProvided {
                    failure(BaseError.emailNeededForOAuth)
                } else if error.errorDescription == OAuthErrorConstants.emailAlreadyInUse {
                    failure(BaseError.emailAlreadyInUseForOAuth)
                } else if error.errorDescription == OAuthErrorConstants.invalidCredentials ||
                          error.errorDescription == OAuthErrorConstants.invalidProvider {
                    failure(BaseError.generic)
                } else {
                    failure(error)
                }
            }
        }
    }
    
    /// Gets the OAuth token and OAuth token secret needed for doing step one of OAuth1 authentication.
    ///
    /// - Parameters:
    ///   - redirectUri: A `String` representing the redirect uri to use for the provider.
    ///   - provider: An `OAuth1Provider` representing the type of provider to use.
    ///   - success: A closure that gets invoked when successful. Passes an `OAuth1Step1Response` with the
    ///              information needed for the given `provider`.
    ///   - failure: A closure that gets invoked when failure occurs. Passes a `BaseError` object that
    ///              contains the error that occured.
    func oauth1Step1(redirectUri: String,
                     provider: OAuth1Provider,
                     success: @escaping (_ oauth1Step1Response: OAuth1Step1Response) -> Void,
                     failure: @escaping (_ error: BaseError) -> Void) {
        let oauth1Step1Info = OAuth1Step1Info(provider: provider, redirectUri: redirectUri)
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.oauth1Step1(oauth1Step1Info: oauth1Step1Info))
            .then(on: DispatchQueue.main) { (oauth1Response: OAuth1Step1Response) -> Void in
                success(oauth1Response)
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Logs in a user using OAuth1 authentication. This is step two of OAuth1 Authentication.
    ///
    /// ## Possible Errors
    ///
    /// 1. When an email wasn't provided when logging into the provider or the provider doesn't give an email
    ///    for the user, the user would be asked to provide an email. Then recall this method with the
    ///    provided email.
    /// 2. When an email given from the provider is already in use in the API, login can't continue and the
    ///    user should be notified.
    /// 3. When an invalid provider is given or the OAuth authorization code is incorrect, the user should be
    ///    notified. This can occur if the token expired or the registered app id and/or redirect url used
    ///    isn't the same as the one the API used.
    /// 4. If the OAuth authorization code can't be parsed, the user should be notified.
    /// 5. If the OAuth token given from the provider does not match the one given from our API from step one,
    ///    login can't continue and the user should be notified.
    ///
    /// - Parameters:
    ///   - redirectUrlWithQueryParameters: A `URL` representing the redirect url that the OAuth1 provider
    ///                                     used. This would contain the OAuth authorization code and OAuth
    ///                                     verifier in it as query parameters.
    ///   - provider: An `OAuth1Provider` representing the type of provider used. This determines how
    ///               `redirectUrlWithQueryParameters` would be parsed.
    ///   - oauth1Response: A `OAuth1Step1Response` representing the info received from step one. This is used
    ///                     for verifying that the oauth token didn't change.
    ///   - email: A `String` representing the email of the user. This would be filled if an email wasn't
    ///            provided to the provider. `nil` can be passed as a parameter.
    ///   - success: A closure that gets invoked when logging in the user was successful.
    ///   - failure: A closure that gets invoked when logging in the user failed. Passes a `BaseError` object
    ///              that contains the error that occured.
    func loginWithOAuth1(redirectUrlWithQueryParameters: URL,
                         provider: OAuth1Provider,
                         oauth1Response: OAuth1Step1Response,
                         email: String?,
                         success: @escaping () -> Void,
                         failure: @escaping (_ error: BaseError) -> Void) {
        let absoluteString = redirectUrlWithQueryParameters.absoluteString
        guard let range = absoluteString.range(of: "&oauth_token=") else {
            failure(BaseError.generic)
            return
        }
        let newRange1 = range.upperBound
        let queryString = String(absoluteString[newRange1...])
        guard let range2 = queryString.range(of: "&oauth_verifier=") else {
            failure(BaseError.generic)
            return
        }
        let newRange2 = range2.lowerBound
        let oauthToken = String(queryString[..<newRange2])
        let newRange3 = range2.upperBound
        let oauthVerifier = String(queryString[newRange3...])
        if oauthToken != oauth1Response.oauthToken {
            failure(BaseError.generic)
            return
        }
        let oauth1Step2Info = OAuth1Step2Info(
            provider: provider,
            oauthToken: oauthToken,
            oauthTokenSecret: oauth1Response.oauthTokenSecret,
            oauthVerifier: oauthVerifier,
            email: email,
            referralCodeOfReferrer: nil
        )
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.oauth1Step2(oauth1Step2Info: oauth1Step2Info))
            .then(on: dispatchQueue) { (oauthResponse: OAuthResponse) in
                SessionManager.shared.authorizationToken = oauthResponse.token
                return networkClient.enqueue(AuthenticationEndpoint.currentUser)
            }
            .then(on: DispatchQueue.main) { (user: User) -> Void in
                SessionManager.shared.currentUser = MultiDynamicBinder(user)
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                if error.errorDescription == OAuthErrorConstants.noEmailProvided {
                    failure(BaseError.emailNeededForOAuth)
                } else if error.errorDescription == OAuthErrorConstants.emailAlreadyInUse {
                    failure(BaseError.emailAlreadyInUseForOAuth)
                } else if error.errorDescription == OAuthErrorConstants.invalidCredentials ||
                    error.errorDescription == OAuthErrorConstants.invalidProvider {
                    failure(BaseError.generic)
                } else {
                    failure(error)
                }
            }
        }
    }
    
    /// Sends a forgot password request for an email.
    ///
    /// - Parameters:
    ///   - email: A `String` representing the email to send a forgot password link to.
    ///   - success:  A closure that gets invoked when sending the link to the email was successful.
    ///   - failure: A closure that gets invoked when sending the link to the email failed. Passes a
    ///              `BaseError` object that contains the error that occured.
    func forgotPasswordRequest(email: String,
                               success: @escaping () -> Void,
                               failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.forgotPasswordRequest(email: email))
            .then(on: DispatchQueue.main) { () -> Void in
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Sends a forgot password reset.
    ///
    /// - Parameters:
    ///   - token: A `String` representing the verification token received from the deep link for forgot
    ///            password.
    ///   - newPassword: A `String` representing the new password the user will use for login.
    ///   - success: A closure that gets invoked when reseting the password was successful.
    ///   - failure: A closure that gets invoked when reseting the password failed. Passes a `BaseError`
    ///              object that contains the error that occured.
    func forgotPasswordReset(token: String,
                             newPassword: String,
                             success: @escaping () -> Void,
                             failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            let endpoint = AuthenticationEndpoint.forgotPasswordReset(
                token: token,
                newPassword: newPassword
            )
            networkClient.enqueue(endpoint)
            .then(on: DispatchQueue.main) { () -> Void in
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Sends a change email request for a new email.
    ///
    /// - Parameters:
    ///   - newEmail: A `String` representing the new email the user wants to use for login.
    ///   - success: A closure that gets invoked when sending the request was successful.
    ///   - failure: A closure that gets invoked when sending the request failed. Passes a `BaseError`
    ///              object that contains the error that occured.
    func changeEmailRequest(newEmail: String,
                            success: @escaping () -> Void,
                            failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.changeEmailRequest(newEmail: newEmail))
            .then(on: DispatchQueue.main) { () -> Void in
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Sends a confirm change email.
    ///
    /// - Parameters:
    ///   - token: A `String` representing the vertification token recevied from the deep link for change
    ///            email request.
    ///   - userId: An `Int` representing the user Id of the user that is changing their email.
    ///   - success: A closure that gets invoked when confirming was successful. 'nil` can be passed as a
    ///              parameter.
    ///   - failure: A closure that gets invoked when confirming failed. Passes a `BaseError` object that
    ///              contains the error that occured. `nil` can be passed as a parameter.
    func changeEmailConfirm(token: String,
                            userId: Int,
                            success: (() -> Void)?,
                            failure: ((_ error: BaseError) -> Void)?) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.changeEmailConfirm(token: token, userId: userId))
            .then(on: DispatchQueue.main) { () -> Void in
                SessionManager.shared.currentUser.value?.newEmailConfirmed = true
                CoreDataStack.shared.saveCurrentState(success: { 
                    guard let closure = success else { return }
                    closure()
                }, failure: {
                    guard let closure = failure else { return }
                    closure(BaseError.generic)
                })
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                guard let closure = failure else { return }
                closure(error)
            }
        }
    }
    
    /// Sends a verify new email.
    ///
    /// - Parameters:
    ///   - token: A `String` representing the token received from the deep link for confirm email.
    ///   - userId: An `Int` representing the user Id of the user that is changing their email.
    ///   - success: A closure that gets invoked when verifying was succesful. When this occurs, the user can
    ///              now use the new email for login.
    ///   - failure: A closure that gets invoked when verifying failed. Passes a `BaseError` object that
    ///              contains the error that occured.
    func changeEmailVerify(token: String,
                           userId: Int,
                           success: @escaping () -> Void,
                           failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.changeEmailVerify(token: token, userId: userId))
            .then(on: DispatchQueue.main) { () -> Void in
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Changes the current user's password.
    ///
    /// - Parameters:
    ///   - currentPassword: A `String` representing the current password the user uses to login.
    ///   - newPassword: A `String` representing the new password the user wishes to use.
    ///   - success: A closure that gets invoked when changing the password was successful.
    ///   - failure: A closure that gets invoked when changing the password failed. Passes a `BaseError`
    ///              object that contains the error that occured.
    func changePassword(currentPassword: String,
                        newPassword: String,
                        success: @escaping () -> Void,
                        failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            let endpoint = AuthenticationEndpoint.changePassword(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
            networkClient.enqueue(endpoint)
            .then(on: DispatchQueue.main) { () -> Void in
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
    
    /// Confirms the user's email from signup.
    ///
    /// - Parameters:
    ///   - token: A `String` representing the token received from the deep link for confirm email.
    ///   - userId: An `Int` representing the user Id of the user that confirmed their email.
    ///   - success: A closure that gets invoked when confirming was successful.
    ///   - failure: A closure that gets invoked when confirming failed. Passes a `BaseError` object that
    ///              contains the error that occured.
    func confirmEmail(token: String,
                      userId: Int,
                      success: @escaping () -> Void,
                      failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(
                baseUrl: ConfigurationManager.shared.apiUrl,
                manageObjectContext: CoreDataStack.shared.managedObjectContext
            )
            networkClient.enqueue(AuthenticationEndpoint.confirmEmail(token: token, userId: userId))
            .then(on: DispatchQueue.main) { () -> Void in
                success()
            }
            .catchAPIError(queue: DispatchQueue.main, policy: .allErrors) { (error: BaseError) in
                failure(error)
            }
        }
    }
}
