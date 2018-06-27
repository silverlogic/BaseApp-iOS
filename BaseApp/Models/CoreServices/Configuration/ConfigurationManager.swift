//
//  ConfigurationManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Environment Mode

/// An enum that declares the different types of run environments for the application.
enum EnvironmentMode: Int {
    case local
    case staging
    case stable
    case production
}


// MARK: - Configuration Manager

/// A singleton responsible for managing global configurations of the application.
final class ConfigurationManager {
    
    // MARK: - Shared Instance
    static let shared = ConfigurationManager()
    
    
    // MARK: - Public Instance Attributes
    
    /// The current environment mode of the application.
    lazy var environmentMode: EnvironmentMode = {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let environmentType = infoDictionary["Environment_Type"] as? Int,
              let environment = EnvironmentMode(rawValue: environmentType) else { return .production }
        return environment
    }()
    
    /// The version number of the application.
    lazy var versionNumber: String = {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let shortVersionNumber = infoDictionary["CFBundleShortVersionString"] as? String else {
                return ""
        }
        return "v\(shortVersionNumber)"
    }()
    
    /// The redirect uri to use for Facebook OAuth.
    lazy var facebookRedirectUri: String = { [weak self] in
        guard let dictionary = self?.valueForKey(ConfigurationConstants.facebook) as? [String: Any],
              let environmentDictionary = self?.valueFromEnvironmentDictionary(dictionary) as? [String: Any],
              let redirectUri = environmentDictionary[ConfigurationConstants.redirectUri] as? String else {
                return ""
        }
        assert(!redirectUri.isEmpty, "Redirect Uri Not Provided In Global Configuration File!")
        return redirectUri
    }()
    
    /// The redirect uri to use for LinkedIn OAuth.
    lazy var linkedInRedirectUri: String = { [weak self] in
        guard let dictionary = self?.valueForKey(ConfigurationConstants.linkedIn) as? [String: Any],
              let environmentDictionary = self?.valueFromEnvironmentDictionary(dictionary) as? [String: Any],
              let redirectUri = environmentDictionary[ConfigurationConstants.redirectUri] as? String else {
                return ""
        }
        assert(!redirectUri.isEmpty, "Redirect Uri Not Provided In Global Configuration File!")
        return redirectUri
    }()
    
    /// The redirect uri to use for Twitter OAuth.
    lazy var twitterRedirectUri: String = { [weak self] in
        guard let dictionary = self?.valueForKey(ConfigurationConstants.twitter) as? [String: Any],
              let environmentDictionary = self?.valueFromEnvironmentDictionary(dictionary) as? [String: Any],
              let redirectUri = environmentDictionary[ConfigurationConstants.redirectUri] as? String else {
                return ""
        }
        assert(!redirectUri.isEmpty, "Redirect Uri Not Provided In Global Configuration File!")
        return redirectUri
    }()
    
    /// The email address to send feedback of the application to.
    lazy var feedbackEmailAddress: String = { [weak self] in
        let key = ConfigurationConstants.feedbackEmailAddress
        guard let feedbackEmail = self?.valueForKey(key) as? String else { return "" }
        return feedbackEmail
    }()
    
    /// The subject line to use for sending feedback email.
    lazy var feedbackEmailSubject: String = { [weak self] in
        guard let strongSelf = self else { return "" }
        let displayName = strongSelf.displayName
        let subject = String(format: NSLocalizedString("Mail.Subject", comment: "email subject"),
                             displayName,
                             Date() as CVarArg)
        return subject
    }()
    
    /// The display name of the application.
    lazy var displayName: String = {
        guard let infoDictionary = Bundle.main.infoDictionary,
            let displayName = infoDictionary["CFBundleDisplayName"] as? String else { return "" }
        return displayName
    }()
    
    
    // MARK: - Private Instance Attributes
    fileprivate lazy var globalConfigurationDictionary: [String: Any] = {
        let resource = ConfigurationConstants.globalConfiguration
        let type = ConfigurationConstants.propertyListType
        guard let localizedFilePath = Bundle.main.path(forResource: resource, ofType: type),
              let dictionary = NSDictionary(contentsOfFile: localizedFilePath) as? [String: Any] else {
                return [String: Any]()
        }
        return dictionary
    }()
    
    
    // MARK: - Initializers
    
    /// Initializes a shared instance of `ConfigurationManager`.
    private init() {}
}


// MARK: - Getters & Setters
extension ConfigurationManager {
    
    // swiftlint:disable line_length
    
    /// The current base api url to use for perfoming network requests.
    var apiUrl: String {
        guard let apiUrlDictionary = valueForKey(ConfigurationConstants.apiUrl) as? [String: Any],
              let apiUrl = valueFromEnvironmentDictionary(apiUrlDictionary) as? String else {
                return ""
        }
        assert(!apiUrl.isEmpty, "API Url Not Provided In Global Configuration File!")
        return apiUrl
    }
    
    /// The url to use for performing Facebook OAuth.
    var facebookOAuthUrl: URL? {
        guard let dictionary = valueForKey(ConfigurationConstants.facebook) as? [String: Any],
              let environmentDictionary = valueFromEnvironmentDictionary(dictionary) as? [String: Any],
              let appId = environmentDictionary[ConfigurationConstants.appId] as? String,
              let url = URL(string: "https://www.facebook.com/dialog/oauth?client_id=\(appId)&redirect_uri=\(facebookRedirectUri)&scope=email,public_profile") else { return nil }
        return url
    }
    
    /// The url to use for performing LinkedIn OAuth.
    var linkedInOAuthUrl: URL? {
        guard let dictionary = valueForKey(ConfigurationConstants.linkedIn) as? [String: Any],
              let environmentDictionary = valueFromEnvironmentDictionary(dictionary) as? [String: Any],
              let appId = environmentDictionary[ConfigurationConstants.appId] as? String else { return nil }
        if ProcessInfo.isRunningUnitTests {
            return URL(string: "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=\(appId)&redirect_uri=\(linkedInRedirectUri)&scope=r_basicprofile%20r_emailaddress")!
        }
        return URL(string: "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=\(appId)&redirect_uri=\(linkedInRedirectUri)&state=\(String.randomStateString(20))&scope=r_basicprofile%20r_emailaddress")!
    }
    
    // swiftlint:enable line_length
}


// MARK: - Private Instance Methods
fileprivate extension ConfigurationManager {
    
    /// Gets the value from the global configuration dictionary based on a given key.
    ///
    /// - Parameter key: A `String` representing a key to a value in the dictionary.
    /// - Returns: An `Any?` representing the value of the given key. If a value can't be retrieved,
    ///            `nil` will be returned.
    fileprivate func valueForKey(_ key: String) -> Any? {
        return globalConfigurationDictionary[key]
    }
    
    /// Gets the value from a given dictionary that has environment modes as keys.
    ///
    /// - Precondition: For an environment dictionary, there should be exactly four key/value pairs. If this
    ///                 condition isn't met, `nil` will be returned.
    ///
    /// - Parameter environmentDictionary: A `[String: Any]` representing the dictionary to retrieve the value
    ///                                    from.
    /// - Returns: An `Any?` representing the value based on the current environment mode. If a value can't be
    ///            retrieved, `nil` will be returned.
    fileprivate func valueFromEnvironmentDictionary(_ environmentDictionary: [String: Any]) -> Any? {
        if environmentDictionary.count != 4 {
            return nil
        }
        switch environmentMode {
        case .local:
            return environmentDictionary[ConfigurationConstants.local]
        case .staging:
            return environmentDictionary[ConfigurationConstants.staging]
        case .stable:
            return environmentDictionary[ConfigurationConstants.stable]
        case .production:
            return environmentDictionary[ConfigurationConstants.production]
        }
    }
}
