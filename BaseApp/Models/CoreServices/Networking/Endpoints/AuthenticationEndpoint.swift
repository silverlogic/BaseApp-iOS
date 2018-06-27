//
//  AuthenticationEndpoint.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
import AlamofireCoreData
import Foundation

// MARK: - OAuth2 Provider Enum

/// An enum that specifies the type of OAuth2 provider.
enum OAuth2Provider: String {
    case facebook = "facebook"
    case linkedIn = "linkedin-oauth2"
}


// MARK: - OAuth1 Provider Enum

/// An enum that specifies the type of OAuth1 provider.
enum OAuth1Provider: String {
    case twitter
}

// swiftlint:disable type_body_length

// MARK: - Authentication Endpoint

/// An enum that conforms to `BaseEndpoint`. It defines endpoints that would be used for authentication.
enum AuthenticationEndpoint: BaseEndpoint {
    case login(email: String, password: String)
    case signUp(signUpInfo: SignUpInfo)
    case update(updateInfo: UpdateInfo, userId: Int)
    case currentUser
    case oauth2(oauth2Info: OAuth2Info)
    case oauth1Step1(oauth1Step1Info: OAuth1Step1Info)
    case oauth1Step2(oauth1Step2Info: OAuth1Step2Info)
    case forgotPasswordRequest(email: String)
    case forgotPasswordReset(token: String, newPassword: String)
    case changeEmailRequest(newEmail: String)
    case changeEmailConfirm(token: String, userId: Int)
    case changeEmailVerify(token: String, userId: Int)
    case changePassword(currentPassword: String, newPassword: String)
    case confirmEmail(token: String, userId: Int)
    
    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        let parameters: Alamofire.Parameters?
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .login(email, password):
            path = "login"
            requestMethod = .post
            parameters = ["email": email, "password": password]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .signUp(signUpInfo):
            path = "register"
            requestMethod = .post
            parameters = signUpInfo.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .update(updateInfo, userId):
            path = "users/\(userId)"
            requestMethod = .patch
            parameters = updateInfo.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
        case .currentUser:
            path = "users/me"
            requestMethod = .get
            parameters = nil
            parameterEncoding = nil
            requiresAuthorization = true
        case let .oauth2(oauth2Info):
            path = "social-auth"
            requestMethod = .post
            parameters = oauth2Info.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .oauth1Step1(oauth1Step1Info):
            path = "social-auth"
            requestMethod = .post
            parameters = oauth1Step1Info.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .oauth1Step2(oauth1Step2Info):
            path = "social-auth"
            requestMethod = .post
            parameters = oauth1Step2Info.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .forgotPasswordRequest(email):
            path = "forgot-password"
            requestMethod = .post
            parameters = ["email": email]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .forgotPasswordReset(token, newPassword):
            path = "forgot-password/reset"
            requestMethod = .post
            parameters = ["token": token, "new_password": newPassword]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .changeEmailRequest(newEmail):
            path = "change-email"
            requestMethod = .post
            parameters = ["new_email": newEmail]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
        case let .changeEmailConfirm(token, userId):
            path = "change-email/\(userId)/confirm"
            requestMethod = .post
            parameters = ["token": token]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .changeEmailVerify(token, userId):
            path = "change-email/\(userId)/verify"
            requestMethod = .post
            parameters = ["token": token]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        case let .changePassword(currentPassword, newPassword):
            path = "users/change-password"
            requestMethod = .post
            parameters = ["current_password": currentPassword, "new_password": newPassword]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
        case let .confirmEmail(token, userId):
            path = "users/\(userId)/confirm-email"
            requestMethod = .post
            parameters = ["token": token]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
        }
        return BaseEndpointInfo(
            path: path,
            requestMethod: requestMethod,
            parameters: parameters,
            parameterEncoding: parameterEncoding,
            requiresAuthorization: requiresAuthorization
        )
    }
}

// swiftlint:enable type_body_length


// MARK: - Sign Up Info

/// A struct encapsulating what information is needed when registering a user.
struct SignUpInfo {
    
    // MARK: - Public Instance Attributes
    let email: String
    let password: String
    let referralCodeOfReferrer: String?
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "email": email,
            "password": password
        ]
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SignUpInfo`.
    ///
    /// - Parameters:
    ///   - email: A `String` representing the email of the user.
    ///   - password: A `String` representing the password that the user would enter when logging in.
    ///   - referralCodeOfReferrer: A `String` representing the referral code of another user that referred
    ///                             the current user to the application. `nil` can be passed if referral code
    ///                             isn't being used.
    init(email: String, password: String, referralCodeOfReferrer: String?) {
        self.email = email
        self.password = password
        self.referralCodeOfReferrer = referralCodeOfReferrer
    }
}


// MARK: - Update Info

/// A struct encapsulating what information is needed when updating a user.
struct UpdateInfo {
    
    // MARK: - Public Instance Attributes
    let referralCodeOfReferrer: String?
    let avatarBaseString: String?
    let firstName: String
    let lastName: String
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "first_name": firstName,
            "last_name": lastName
        ]
        if let baseString = avatarBaseString {
            params["avatar"] = baseString
        }
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `UpdateInfo`.
    ///
    /// - Parameters:
    ///   - referralCodeOfReferrer: A `String` representing the referral code of another user that referred
    ///                             the current user to the application. This is used when the user signs up
    ///                             through social authentication. In regular email signup, `nil` would be
    ///                             passed.
    ///   - avatarBaseString: A `String` representing the base sixty four representation of an image. `nil`
    ///                       can be passed if no imaged was selected or changed.
    ///   - firstName: A `String` representing the first name of the user.
    ///   - lastName: A `String` representing the last name of the user.
    init(referralCodeOfReferrer: String?, avatarBaseString: String?, firstName: String, lastName: String) {
        self.referralCodeOfReferrer = referralCodeOfReferrer
        self.avatarBaseString = avatarBaseString
        self.firstName = firstName
        self.lastName = lastName
    }
}


// MARK: - OAuth2 Info

/// A struct encapsulating what information is needed hen doing OAuth2 Authentication.
struct OAuth2Info {
    
    // MARK: - Public Instance Methods
    let provider: String
    let oauthCode: String
    let redirectUri: String
    let email: String?
    let referralCodeOfReferrer: String?
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "provider": provider,
            "code": oauthCode,
            "redirect_uri": redirectUri
        ]
        if let userEmail = email {
            params["email"] = userEmail
        }
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `OAuth2Info`.
    ///
    /// - Parameters:
    ///   - provider: An `OAuth2Provider` representing the type of OAuth provider used.
    ///   - oauthCode: A `String` representing the OAuth authorization code that is received from an OAuth2
    ///                provider.
    ///   - redirectUri: A `String` representing the redirect used for the provider.
    ///   - email: A `String` representing the email of the user used for logining in to the provider.
    ///            This value would be filled if an error occured due to an email not being used for login.
    ///            `nil` can be passed as a parameter.
    ///   - referralCodeOfReferrer: A `String` representing the referral code of another user that the
    ///                             referred the current user to the application. In some situations, if the
    ///                             referral code can't be supplied due to the `oauthCode` expiring, the
    ///                             `UpdateInfo` can be used to pass the referral code. This only avaliable
    ///                             for twenty four hours after the user logged in. `nil` can be passed as a
    ///                             parameter.
    init(provider: OAuth2Provider,
         oauthCode: String,
         redirectUri: String,
         email: String?,
         referralCodeOfReferrer: String?) {
        self.provider = provider.rawValue
        self.oauthCode = oauthCode
        self.redirectUri = redirectUri
        self.email = email
        self.referralCodeOfReferrer = referralCodeOfReferrer
    }
}


// MARK: - OAuth1 Step1 Info

/// A struct encapsulating what information is needed for completing step one of OAuth1 Authentication.
///
/// - SeeAlso: https://developers.baseapp.tsl.io/users/social-auth/
struct OAuth1Step1Info {
    
    // MARK: - Public Instance Attributes
    let provider: String
    let redirectUri: String
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        let params: Parameters = [
            "provider": provider,
            "redirect_uri": redirectUri
        ]
        return params
    }
    
    
    // MARK: - Initializers
    
    /// Initiailizes an instance of `OAuth1Step1Info`.
    ///
    /// - Parameters:
    ///   - provider: A `OAuth1Provider` representing the type of OAuth provider used.
    ///   - redirectUri: A `String` representing the redirect used for the provider.
    init(provider: OAuth1Provider, redirectUri: String) {
        self.provider = provider.rawValue
        self.redirectUri = redirectUri
    }
}


// MARK: - OAuth1 Step2 Info

/// A struct encapsulating what information is needed for completing step two of OAuth1 Authentication.
///
/// - SeeAlso: https://developers.baseapp.tsl.io/users/social-auth/
struct OAuth1Step2Info {
    
    // MARK: - Public Instance Attributes
    let provider: String
    let oauthToken: String
    let oauthTokenSecret: String
    let oauthVerifier: String
    let email: String?
    let referralCodeOfReferrer: String?
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params = [
            "provider": provider,
            "oauth_token": oauthToken,
            "oauth_token_secret": oauthTokenSecret,
            "oauth_verifier": oauthVerifier
        ]
        if let userEmail = email {
            params["email"] = userEmail
        }
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `OAuth1Step2Info`.
    ///
    /// - Parameters:
    ///   - provider: A `OAuth1Provider` representing the type of OAuth provider used.
    ///   - oauthToken: A `String` representing the OAuth token recieved from the provider.
    ///   - oauthTokenSecret: A `String` representing the secret used for the provider.
    ///   - oauthVerifier: A `String` representing the verifier recieved from the provider.
    ///   - email: A `String` representing the email of the user used for logining in to the provider.
    ///            This value would be filled if an error occured due to an email not being used for login.
    ///            `nil` can be passed as a parameter.
    ///   - referralCodeOfReferrer: A `String` representing the referral code of another user that the
    ///                             referred the current user to the application. In some situations, if the
    ///                             referral code can't be supplied due to the `oauthToken` expiring, the
    ///                             `UpdateInfo` can be used to pass the referral code. This only avaliable
    ///                             for twenty four hours after the user logged in. `nil` can be passed as a
    ///                             parameter.
    init(provider: OAuth1Provider,
         oauthToken: String,
         oauthTokenSecret: String,
         oauthVerifier: String,
         email: String?,
         referralCodeOfReferrer: String?) {
        self.provider = provider.rawValue
        self.oauthToken = oauthToken
        self.oauthTokenSecret = oauthTokenSecret
        self.oauthVerifier = oauthVerifier
        self.email = email
        self.referralCodeOfReferrer = referralCodeOfReferrer
    }
}


// MARK: - Login Response

/// A struct representing the object sent back from the API when logging in a user
struct LoginResponse: Wrapper {
    
    // MARK: - Public Instance Attributes
    var token: String!
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `LoginResponse`. This is used to conform to the protocol `Wrapper`.
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        token <- map["token"]
    }
}


// MARK: - OAuth Response

/// A struct representing the object sent back from the API when logging in a user using OAuth.
struct OAuthResponse: Wrapper {
    
    // MARK: - Public Instance Attributes
    var token: String!
    var isNewUser: Bool!
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `OAuthResponse`. This is used to conform to the protocol `Wrapper`.
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        token <- map["token"]
        isNewUser <- map["is_new"]
    }
}


// MARK: - OAuth1 Step1 Response

/// A struct representing the object sent back from the API for step one of OAuth1 authentication.
struct OAuth1Step1Response: Wrapper {
    
    // MARK: - Public Instance Attributes
    var oauthTokenSecret: String!
    var oauthCallBackConfirmed: String!
    var oauthToken: String!
    
    
    // MARK: - Initializers

    /// Initializes an instance of `OAuth1Step1Response`. This is used to conform to the protocol `Wrapper`.
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        oauthTokenSecret <- map["oauth_token_secret"]
        oauthCallBackConfirmed <- map["oauth_callback_confirmed"]
        oauthToken <- map["oauth_token"]
    }
}
