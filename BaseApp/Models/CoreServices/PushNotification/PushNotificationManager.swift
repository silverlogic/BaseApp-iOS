//
//  PushNotificationManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A singleton responsible for registering for and handling incoming push notifications from Apple's Push
/// Notification Service.
final class PushNotificationManager {
    
    // MARK: - Shared Instance
    static let shared = PushNotificationManager()
    
    
    // MARK: - Public Instance Attributes

    /// Determines if the user has registered to receive push notifications or not.
    lazy var isRegistered: Bool = {
        let key = PushNotificationConstants.isRegistered
        guard let status = UserDefaults.standard.value(forKey: key) as? Bool else {
            return false
        }
        return status
    }()
    
    /// The device token received from Apple's Push Notification Service. Can use this for testing.
    var deviceToken: String?
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `PushNotificationManager`.
    private init() {}
}


// MARK: - Public Instance Methods For Registration.
extension PushNotificationManager {
    
    /// Registers the user to receive push notifications. This method should be called during the tutorial
    /// flow.
    ///
    /// - Note: Here you can define notification actions.
    func registerForPushNotifications() {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert],
                                                              categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    /// Handles the registration of the notification settings. This method would get called in the app
    /// delegate's `didRegister notificationSettings` delegate method. It then registers for remote
    /// notifications based on the types the user has allowed for.
    ///
    /// - Parameter notificationSettings: A `UIUserNotificationSettings` object representing the settings the
    ///                                   user has allowed for the application.
    func handleRegistrationOfUserNotificationSettings(_ notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    /// Handles the registration of remote notifications when successful. It takes the device token received
    /// from Apple's Push Notification Service and sends it to the API to use. This method would get called in
    /// the app delegate's `didRegisterForRemoteNotificationsWithDeviceToken` delegate method.
    ///
    /// - Parameter deviceToken: A `Data` representing the device token received. This token would be used by
    ///                          the API to send push notifications to the correct device.
    func handleRegistrationOfRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        guard var token = String(data: deviceToken, encoding: .utf8) else { return }
        token = token.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        token = token.replacingOccurrences(of: " ", with: "")
        AppLogger.shared.logMessage("Device Token Received: \(token)", for: .debug, debugOnly: true)
        self.deviceToken = token
        isRegistered = true
        if !ProcessInfo.isRunningUnitTests {
            UserDefaults.standard.set(isRegistered, forKey: PushNotificationConstants.isRegistered)
        }
        // @TODO: Call endpoint for sending token to API when endpoint exists
    }

    /// Handles the registration of remote notifications when failure occurs. It takes the error received and
    /// outputs the description to the console. This method would get called in the app delegate's
    /// `didFailToRegisterForRemoteNotificationsWithError` delegate method.
    ///
    /// - Parameter error: An `Error` representing the error that occured.
    func handleRegistrationOfRemoteNotificationsWithError(_ error: Error) {
        AppLogger.shared.logMessage(error.localizedDescription, for: .error)
        isRegistered = false
        if !ProcessInfo.isRunningUnitTests {
            UserDefaults.standard.set(isRegistered, forKey: PushNotificationConstants.isRegistered)
        }
    }
}


// MARK: - Public Instance Methods For Push Notification Incoming
extension PushNotificationManager {
    
    
    /// Handles an incoming push notification from Apple's Push Notification Service.
    ///
    /// ## Places To Invoke Method
    ///
    /// 1. If the application is not running and the user launches it by tapping on the notification, invoke
    ///    in the app delegate's `didFinishLaunchingWithOptions` delegate method.
    /// 2. If the application is running in the foreground and the push notification is not shown, invoke in
    ///    the app delegate's `didReceiveRemoteNotification` delegate method.
    /// 3. If the application was running or suspended in the background, and the user tapped on the
    ///    notification, invoke in the app delegate's `didReceiveRemoteNotification`.
    ///
    /// - Parameter notificationPayload: A `[String: Any]` representing the payload sent from the API to
    ///                                  Apple's Push Notification Service. This would contain the type of
    ///                                  notification sent and what info needed to handle it.
    func handleIncomingPushNotification(notificationPayload: [String: Any]) {
        // @TODO: Handle payload and parse dictionary.
    }
    
    /// Handles an incoming push notification with a notification action from Apple's Push Notification
    /// Service. This method would be invoked in the app delegate's `handleActionWithIdentifier` delegate
    /// method.
    ///
    /// - Parameters:
    ///   - notificationPayload: A `[String: Any]` representing the payload sent from the API to Apple's Push
    ///                          Notification Service. This would contain the type of notification sent and
    ///                          what info needed to handle it.
    ///   - identifier: A `String` representing action identifier of the notification.
    func handleIncomingPushNotificationWithAction(notificationPayload: [String: Any], identifier: String) {
        // @TODO: Handle payload and parse dictionary.
    }
}
