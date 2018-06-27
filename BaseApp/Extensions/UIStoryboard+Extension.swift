//
//  UIStoryboard+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Storyboard Name Enum

/// An enum that specifies which storyboard to load.
private enum Storyboard: String {
    case main = "Main"
    case authentication = "Authentication"
}


// MARK: - UIStoryboard Extensions

// MARK: - Public Class Methods For UIViewController Loaders
extension UIStoryboard {
    
    /// Loads the intial view controller for the application.
    ///
    /// - Returns: A `BaseTabBarController` represenitng the intiail view controller.
    static func loadInitialViewController() -> BaseTabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() as? BaseTabBarController else {
            fatalError("BaseTabBarController does not exist in Main.storyboard!")
        }
        return controller
    }
    
    /// Loads the login view controller.
    ///
    /// - Returns: A `LoginViewController` representing the login view controller.
    static func loadLoginViewController() -> LoginViewController {
        return loadControllerFromAuthenticaton(type: LoginViewController.self)
    }
    
    /// Loads the forgot password reset view controller.
    ///
    /// - Returns: A `ForgotPasswordResetViewController` representing the forgot password reset view
    ///            controller.
    static func loadForgotPasswordResetViewController() -> ForgotPasswordResetViewController {
        return loadControllerFromAuthenticaton(type: ForgotPasswordResetViewController.self)
    }
    
    /// Loads the change email verify view controller.
    ///
    /// - Returns: A `ChangeEmailVerifyViewController` representing the change email verify view controller.
    static func loadChangeEmailVerifyViewController() -> ChangeEmailVerifyViewController {
        return loadControllerFromAuthenticaton(type: ChangeEmailVerifyViewController.self)
    }
}


// MARK: - Private Class Methods
private extension UIStoryboard {
    
    /// Loads a view controller from the main storyboard.
    ///
    /// - Parameter type: A `UIViewController.Type` indicating what type to load.
    /// - Returns: A `T` representing the view controller to load.
    static func loadControllerFromMain<T: UIViewController>(type: T.Type) -> T {
        return loadControllerFrom(.main, type: type)
    }
    
    /// Loads a view controller from the authentication storyboard.
    ///
    /// - Parameter type: A `UIViewController.Type` indicating what type to load.
    /// - Returns: A `T` representing the view controller to load.
    static func loadControllerFromAuthenticaton<T: UIViewController>(type: T.Type) -> T {
        return loadControllerFrom(.authentication, type: type)
    }
    
    /// Loads a view controller from a storyboard.
    ///
    /// - Parameters:
    ///   - storyboard: A `Storyboard` represeting the storyboard to load the view controller from.
    ///   - type: A `UIViewController.Type` representing the type to load.
    /// - Returns: A `T` representing the view controller to load.
    static func loadControllerFrom<T: UIViewController>(_ storyboard: Storyboard, type: T.Type) -> T {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        // swiftlint:disable line_length
        guard let controller = uiStoryboard.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("View Controller in storyboard does not have identifier set!")
        }
        // swiftlint:enable line_length
        return controller
    }
}
