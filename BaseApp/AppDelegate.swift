//
//  AppDelegate.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import AlamofireNetworkActivityIndicator
import Crashlytics
import Dodo
import Fabric
import IQKeyboardManager
import Onboard
import SVProgressHUD
import UIKit

final class AppDelegate: UIResponder {
    
    // MARK: - Public Instance Methods
    var window: UIWindow?
}


// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        _ = ConfigurationManager.shared
        _ = CoreDataStack.shared
        _ = AppLogger.shared
        _ = SessionManager.shared
        _ = DeepLinkManager.shared
        _ = PushNotificationManager.shared
        return true
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadAuthenticationFlow),
                                               name: .UserLoggedOut,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadApplicationFlow),
                                               name: .UserLoggedIn,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadForgotPasswordResetFlow(
                                                notification:)),
                                               name: .PasswordReset,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadTutorialFlow),
                                               name: .ShowTutorial,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeEmailConfirm(notification:)),
                                               name: .ChangeEmailConfirm,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadChangeEmailVerifyFlow(notification:)),
                                               name: .ChangeEmailVerify,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(confirmEmail(notification:)),
                                               name: .ConfirmEmail,
                                               object: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        setInitialFlow()
        configureBusinessLogic(launchOptions: launchOptions)
        configureUIComponents()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        DeepLinkManager.shared.respondToUrlScheme(url)
        return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        DeepLinkManager.shared.respondToUniversalLink(userActivity: userActivity)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func application(_ application: UIApplication,
                     didRegister notificationSettings: UIUserNotificationSettings) {
        // @TODO: Uncomment if implementing Push Notifications in your application.
//        PushNotificationManager.shared.handleRegistrationOfUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // @TODO: Uncomment if implementing Push Notifications in your application.
//        PushNotificationManager.shared.handleRegistrationOfRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // @TODO: Uncomment if implementing Push Notifications in your application.
//        PushNotificationManager.shared.handleRegistrationOfRemoteNotificationsWithError(error)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // @TODO: Uncomment if implementing Push Notifications in your application.
//        guard let notificationPayload = userInfo as? [String: Any] else { return }
//        PushNotificationManager.shared.handleIncomingPushNotification(notificationPayload:
//            notificationPayload)
    }
    
    func application(_ application: UIApplication,
                     handleActionWithIdentifier identifier: String?,
                     forRemoteNotification userInfo: [AnyHashable: Any],
                     completionHandler: @escaping () -> Void) {
        // @TODO: Uncomment if implementing Push Notifications in your application.
//        guard let notificationPayload = userInfo as? [String: Any],
//              let actionIdentifier = identifier else { return }
//        PushNotificationManager.shared.handleIncomingPushNotificationWithAction(notificationPayload:
//            notificationPayload,
//                                                                                identifier:
//            actionIdentifier)
//        completionHandler()
    }
}


// MARK: - Public Instance Methods
extension AppDelegate {
    
    /// Updates the appearance proxy.
    func updateAppearance() {
        configureUIComponents()
    }
}


// MARK: - Private Instance Methods
private extension AppDelegate {
    
    /// Determines which flow the user should begin with based on their current session.
    func setInitialFlow() {
        // Check if running integration tests
        if ProcessInfo.isRunningIntegrationTests {
            loadAuthenticationFlow()
            return
        }
        if SessionManager.shared.authorizationToken == nil {
            loadAuthenticationFlow()
            return
        }
        loadApplicationFlow()
    }
    
    /// Configures default UI components used universally.
    func configureUIComponents() {
        var font = UIFont.mainRegularMedium
        if UIDevice.current.userInterfaceIdiom == .pad {
            font = .mainRegularLarge
        }
        SVProgressHUD.setFont(font)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(.main)
        SVProgressHUD.setBackgroundColor(.white)
        NetworkActivityIndicatorManager.shared.isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        DodoBarDefaultStyles.hideAfterDelaySeconds = 3
        DodoLabelDefaultStyles.font = font
        DodoBarDefaultStyles.locationTop = false
        window?.rootViewController?.view.dodo.topLayoutGuide = window?.rootViewController?.topLayoutGuide
        window?.rootViewController?.view.dodo.bottomLayoutGuide = window?.rootViewController?
            .bottomLayoutGuide
        let navtitleTextAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.white,
            .font: font
        ]
        UINavigationBar.appearance().titleTextAttributes = navtitleTextAttributes
        UINavigationBar.appearance().tintColor = .white
        // Uncomment if solid color is desired
        // For image background, change in BaseNavigationController
//        UINavigationBar.appearance().backgroundColor = .main
        let barTitleTextAttributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.white,
            .font: font
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(barTitleTextAttributes, for: .normal)
    }
    
    /// Configures default business logic used universally.
    ///
    /// - Parameter launchOptions: A `[UIApplicationLaunchOptionsKey: Any]` representing the launch options
    ///                            received from the app delegate.
    func configureBusinessLogic(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Fabric.sharedSDK().debug = false
        Fabric.with([Crashlytics.self()])
        DeepLinkManager.shared.initializeBranchIOSession(launchOptions: launchOptions)
        // @TODO: Uncomment if implementing Push Notifications in your application.
//        if PushNotificationManager.shared.isRegistered {
//            PushNotificationManager.shared.registerForPushNotifications()
//        }
//        if let notificationPayload = launchOptions?[.remoteNotification] as? [String: AnyObject] {
//            PushNotificationManager
//                .shared
//                .handleIncomingPushNotification(notificationPayload: notificationPayload)
//        }
        guard SessionManager.shared.authorizationToken != nil,
              let user = SessionManager.shared.currentUser.value else { return }
        Crashlytics.sharedInstance().setUserIdentifier("\(user.userId)")
        Crashlytics.sharedInstance().setUserEmail(user.email)
    }
    
    /// Loads the authentication flow.
    @objc func loadAuthenticationFlow() {
        let loginViewController = UIStoryboard.loadLoginViewController()
        loginViewController.loginViewModel = ViewModelsManager.loginViewModel()
        let navigationController = AuthenticationNavigationController(rootViewController: loginViewController)
        let snapshot = (window?.snapshotView(afterScreenUpdates: true))!
        navigationController.view.addSubview(snapshot)
        window?.rootViewController = navigationController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /// Loads the application flow.
    @objc func loadApplicationFlow() {
        let rootController = UIStoryboard.loadInitialViewController()
        rootController.selectedIndex = TabbarIndex.users.rawValue
        let snapshot = (window?.snapshotView(afterScreenUpdates: true))!
        rootController.view.addSubview(snapshot)
        window?.rootViewController = rootController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /// Loads the forgot password reset flow.
    ///
    /// - Note: In `notification`, it contains the token received from forgot password deep linking in the
    ///         property `object`.
    ///
    /// - Parameter notification: A `Notification` representing the notification that was fired for forgot
    ///                           password deep linking.
    @objc func loadForgotPasswordResetFlow(notification: Notification) {
        guard let token = notification.object as? String else { return }
        let rootViewController = UIStoryboard.loadForgotPasswordResetViewController()
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: token)
        rootViewController.forgotPasswordViewModel = forgotPasswordViewModel
        let navigationController = AuthenticationNavigationController(rootViewController: rootViewController)
        let snapshot = (window?.snapshotView(afterScreenUpdates: true))!
        navigationController.view.addSubview(snapshot)
        window?.rootViewController = navigationController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /// Loads the tutorial flow.
    @objc func loadTutorialFlow() {
        var title = NSLocalizedString("Tutorial.PartOne.Title", comment: "title")
        var body = NSLocalizedString("Tutorial.PartOne.Body", comment: "title")
        var image = #imageLiteral(resourceName: "icon-pushnotificationtutorial")
        var buttonText = NSLocalizedString("Tutorial.PartOne.ButtonText", comment: "title")
        let firstViewController = OnboardingContentViewController(title: title,
                                                                  body: body,
                                                                  image: image,
                                                                  buttonText: buttonText) {
            // @TODO: Uncomment if implementing Push Notifications in your application.
//            PushNotificationManager.shared.registerForPushNotifications()
        }
        title = NSLocalizedString("Tutorial.PartTwo.Title", comment: "title")
        body = NSLocalizedString("Tutorial.PartTwo.Body", comment: "title")
        image = #imageLiteral(resourceName: "icon-locationupdatetutorial")
        buttonText = NSLocalizedString("Tutorial.PartTwo.ButtonText", comment: "title")
        let secondViewController = OnboardingContentViewController(title: title,
                                                                   body: body,
                                                                   image: image,
                                                                   buttonText: buttonText) {
            // @TODO: Prompt for location update permission
        }
        title = NSLocalizedString("Tutorial.PartThree.Title", comment: "title")
        body = NSLocalizedString("Tutorial.PartThree.Body", comment: "title")
        image = #imageLiteral(resourceName: "icon-friendstutorial")
        buttonText = NSLocalizedString("Tutorial.PartThree.ButtonText", comment: "title")
        let thirdViewController = OnboardingContentViewController(title: title,
                                                                  body: body,
                                                                  image: image,
                                                                  buttonText: buttonText) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadApplicationFlow()
        }
        let pageControllers: [OnboardingContentViewController] = [firstViewController,
                                                                  secondViewController,
                                                                  thirdViewController]
        let onboardViewController = OnboardingViewController(backgroundImage: #imageLiteral(resourceName: "background-baseapp"),
                                                             contents: pageControllers)
        onboardViewController?.shouldFadeTransitions = true
        onboardViewController?.shouldMaskBackground = false
        onboardViewController?.fadeSkipButtonOnLastPage = true
        onboardViewController?.allowSkipping = true
        onboardViewController?.skipHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadApplicationFlow()
        }
        let snapshot = (window?.snapshotView(afterScreenUpdates: true))!
        onboardViewController?.view.addSubview(snapshot)
        window?.rootViewController = onboardViewController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /// Performs part two of change email.
    ///
    /// - Note: In `notification`, it contains the token and the user Id received from change email request
    ///         deep linking.
    ///
    /// - Parameter notification: A `Notification` representing the notification that was fired for change
    ///                           email request deep linking.
    @objc func changeEmailConfirm(notification: Notification) {
        guard let parameters = notification.object as? [String: Any],
              let token = parameters["token"] as? String,
              let userId = parameters["userId"] as? Int else { return }
        AuthenticationManager.shared.changeEmailConfirm(
            token: token,
            userId: userId,
            success: nil,
            failure: nil
        )
    }
 
    /// Loads the change email verify flow.
    ///
    /// - Note: In `notification`, it contains the token and the user Id received from change email confirm
    ///         deep linking.
    ///
    /// - Parameter notification: A `Notification` representing the notification that was fired for change
    ///                           email confirm deep linking.
    @objc func loadChangeEmailVerifyFlow(notification: Notification) {
        guard let parameters = notification.object as? [String: Any],
              let token = parameters["token"] as? String,
              let userId = parameters["userId"] as? Int else { return }
        let rootViewController = UIStoryboard.loadChangeEmailVerifyViewController()
        let changeEmailVerifyViewModel = ViewModelsManager.changeEmailVerifyViewModel(token: token,
                                                                                      userId: userId)
        rootViewController.changeEmailVerifyViewModel = changeEmailVerifyViewModel
        let navigationController = AuthenticationNavigationController(rootViewController: rootViewController)
        let snapshot = (window?.snapshotView(afterScreenUpdates: true))!
        navigationController.view.addSubview(snapshot)
        window?.rootViewController = navigationController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /// Performs confirm email.
    ///
    /// - Note: In `notification`, it contains the token and the user Id received from confirm email deep
    ///         link.
    ///
    /// - Parameter notification: A `Notification` representing the notification that was fired for confirm
    ///                           email deep linking.
    @objc func confirmEmail(notification: Notification) {
        guard let parameters = notification.object as? [String: Any],
              let token = parameters["token"] as? String,
              let userId = parameters["userId"] as? Int else { return }
        AuthenticationManager.shared.confirmEmail(token: token, userId: userId, success: { [weak self] in
            guard let strongSelf = self else { return }
            let alertMeesage = NSLocalizedString("ConfirmEmail.EmailConfirmed", comment: "alert message")
            strongSelf.window?.rootViewController?.showDodoAlert(message: alertMeesage, alertType: .success)
            if SessionManager.shared.authorizationToken != nil {
                SessionManager.shared.currentUser.value?.emailConfirmed = true
                CoreDataStack.shared.saveCurrentState(success: {}, failure: {
                    // Reload user
                    AuthenticationManager.shared.currentUser(success: {}, failure: { _ in
                        // Logout user
                        SessionManager.shared.logout()
                    })
                })
            }
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.window?.rootViewController?.showDodoAlert(message: error.errorDescription,
                                                                 alertType: .error)
        }
    }
}
