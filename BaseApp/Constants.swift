//
//  Constants.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Configuration Constants

/// An enum that defines constants used for configuration of the application.
enum ConfigurationConstants {
    
    // MARK: - File Constants
    static let globalConfiguration = "globalconfiguration"
    
    
    // MARK: - File Type Constants
    static let propertyListType = "plist"
    
    
    // MARK: - Environment Keys
    static let local = "Local"
    static let staging = "Staging"
    static let stable = "Stable"
    static let production = "Production"
    
    
    // MARK: - OAuth Keys
    static let appId = "AppId"
    static let redirectUri = "RedirectUri"
    
    
    // MARK: - Generic Keys
    static let apiUrl = "ApiUrl"
    static let crashlytics = "Crashlytics"
    static let facebook = "Facebook"
    static let linkedIn = "LinkedIn"
    static let twitter = "Twitter"
    static let feedbackEmailAddress = "FeedbackEmailAddress"
}


// MARK: - CoreData Stack Constants

/// An enum that defines constants used for setting up the Core Data stack of the application.
enum CoreDataStackConstants {
    
    // MARK: - File Constants
    static let model = "Model"
    static let sqLite = "Model.sqlite"
    
    
    // MARK: - File Type Constants
    static let modelType = "momd"
}


// MARK: - Session Constants

/// An enum that defines constants used for managing the session of the current user.
enum SessionConstants {
    
    // MARK: - User Constants
    static let userId = "userId"
    
    
    // MARK: - Authorization Token Constants
    static let authorizationToken = "authorizationToken"
}


// MARK: - Push Notification Constants

/// An enum that defines constants used for knowing the registration status of push notifications.
enum PushNotificationConstants {
    
    // MARK: - Registration Constants
    static let isRegistered = "isRegistered"
}


// MARK: - Style Constants

/// An enum that defines constants used for styling the application.
enum StyleConstants {
    
    // MARK: - Keyboard Constants
    static let keyboardStyle: UIKeyboardAppearance = .default
}


// MARK: - OAuth Error Constants

/// An enum that defines constants used for identifying OAuth errors that can occur.
enum OAuthErrorConstants {
    static let invalidProvider = "Invalid provider 😞"
    static let invalidCredentials = "invalid_credentials 😞"
    static let noEmailProvided = "no_email_provided 😞"
    static let emailAlreadyInUse = "email_already_in_use 😞"
}


// MARK: - Tabbar Index Enum

/// An enum that defines the indexes of the tabbar.
enum TabbarIndex: Int {
    case profile
    case users
    case settings
}
