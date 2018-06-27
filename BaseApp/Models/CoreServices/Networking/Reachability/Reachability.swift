//
//  Reachability.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/19/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
import Foundation

// MARK: - Connection Status Enum

/// An enum that specifies the connection status of the device.
enum ConnectionStatus {
    case unknown
    case connected
    case notConnected
}


// MARK: - Reachability

/// A singleton responsible for listening for changes in the network connection status of the device.
final class Reachability {
    
    // MARK: - Shared Instance
    static let shared = Reachability()
    
    
    // MARK: - Private Instance Attributes
    private let reachabilityManager: NetworkReachabilityManager?
    
    
    // MARK: - Public Instance Attributes
    var connectionStatus: MultiDynamicBinder<ConnectionStatus>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `Reachability`.
    private init() {
        connectionStatus = MultiDynamicBinder(.unknown)
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.listener = { [weak self] status in
            guard let strongSelf = self else { return }
            switch status {
            case .unknown:
                strongSelf.connectionStatus.value = .unknown
            case .notReachable:
                strongSelf.connectionStatus.value = .notConnected
            case .reachable(.ethernetOrWiFi), .reachable(.wwan):
                strongSelf.connectionStatus.value = .connected
            }
        }
        reachabilityManager?.startListening()
    }
    
    
    // MARK: - Deinitializers
    
    /// Deinitializes an instance of `Reachability`.
    deinit {
        reachabilityManager?.stopListening()
    }
}


// MARK: - Public Instance Methods For Connection Type
extension Reachability {
    
    /// Determines if the device is connected to a network.
    ///
    /// - Returns: A `Bool` indiciating if the device is connected or not. If the status can't be determined,
    ///            `nil` will be returned.
    func isConnected() -> Bool? {
        guard let manager = reachabilityManager else { return nil }
        return manager.isReachable
    }
    
    /// Determines if the device is connected with Wifi.
    ///
    /// - Returns: A `Bool` indiciating if the device is connected or not. If the status can't be determined,
    ///            `nil` will be returned.
    func isConnectedByWifi() -> Bool? {
        guard let manager = reachabilityManager else { return nil }
        return manager.isReachableOnEthernetOrWiFi
    }
    
    /// Determines if the device is connected with the Cell Network.
    ///
    /// - Returns: A `Bool` indiciating if the device is connected or not. If the status can't be determined,
    ///            `nil` will be returned.
    func isConnectedByCellNetwork() -> Bool? {
        guard let manager = reachabilityManager else { return nil }
        return manager.isReachableOnWWAN
    }
}
