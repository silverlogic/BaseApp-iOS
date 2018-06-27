//
//  PushNotificationManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class PushNotificationManagerTests: BaseUnitTests {
    
    // MARK: - Private Attributes
    fileprivate var sharedManager: PushNotificationManager!
    
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        sharedManager = PushNotificationManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        sharedManager = nil
    }
}


// MARK: - Functional Tests
extension PushNotificationManagerTests {
    func testRegisterForPushNotifications() {
        sharedManager.registerForPushNotifications()
    }
    
    func testHandleRegistrationOfUserNotificationSettings() {
        sharedManager
        .handleRegistrationOfUserNotificationSettings(UIUserNotificationSettings(types: [], categories: nil))
    }
    
    func testHandleRegistrationOfRemoteNotificationsWithDeviceToken() {
        let testString = "<cd33978b 3a77ea3e a6cf6295 84d80a5c e6ec55a9 56f993a8 f7851d02 dd7cad81>"
        guard let deviceToken = testString.data(using: .utf8) else {
            XCTFail("Can't Test Push Notification Handle With Device Token!")
            return
        }
        sharedManager.handleRegistrationOfRemoteNotificationsWithDeviceToken(deviceToken)
        guard let testToken = sharedManager.deviceToken else {
            XCTFail("Parsing Token Failed!")
            return
        }
        XCTAssertEqual(testToken,
                       "cd33978b3a77ea3ea6cf629584d80a5ce6ec55a956f993a8f7851d02dd7cad81",
                       "Token Not Parsed Correctly!")
    }
    
    func testHandleRegistrationOfRemoteNotificationsWithError() {
        sharedManager.handleRegistrationOfRemoteNotificationsWithError(BaseError.generic)
    }
    
    func testHandleIncomingPushNotification() {
        // @TODO: Adjust when push notifications are in use
        sharedManager.handleIncomingPushNotification(notificationPayload: ["Bob": "Saget"])
    }
    
    func testHandleIcomingPushNotificationWithAction() {
        // @TODO: Adjust when push notifications are in use
        sharedManager.handleIncomingPushNotificationWithAction(notificationPayload: ["Bob": "Saget"],
                                                               identifier: "FULL_HOUSE")
    }
}
