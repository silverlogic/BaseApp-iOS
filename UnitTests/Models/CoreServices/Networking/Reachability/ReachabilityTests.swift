//
//  ReachabilityTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/19/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class ReachabilityTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testConnectionStatusBinder() {
        let connectionStatusExpectation = expectation(description: "Test Connection Status Listener")
        Reachability.shared.connectionStatus.interface.bindAndFire({ _ in
            connectionStatusExpectation.fulfill()
        }, for: self)
        waitForExpectations(timeout: 10) { (error: Error?) in
            if error != nil {
                XCTFail("Error With Binder!")
                Reachability.shared.connectionStatus.interface.unbind(for: self)
                return
            }
            Reachability.shared.connectionStatus.interface.unbind(for: self)
        }
    }
    
    func testIsConnected() {
        XCTAssertNotNil(Reachability.shared.isConnected(), "Value Shouldn't Be Nil!")
    }
    
    func testIsConnectedByWifi() {
        XCTAssertNotNil(Reachability.shared.isConnectedByWifi(), "Value Shouldn't Be Nil!")
    }
    
    func testIsConnectByCellNetwork() {
        XCTAssertNotNil(Reachability.shared.isConnectedByCellNetwork(), "Value Shouldn't Be Nil!")
    }
}
