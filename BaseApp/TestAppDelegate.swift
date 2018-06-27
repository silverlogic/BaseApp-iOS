//
//  TestAppDelegate.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit

final class TestAppDelegate: UIResponder {
    
    // MARK: - Public Instance Methods
    var window: UIWindow?
}


// MARK: - UIApplicationDelegate
extension TestAppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        _ = ConfigurationManager.shared
        _ = CoreDataStack.shared
        _ = AppLogger.shared
        _ = SessionManager.shared
        return true
    }
}
