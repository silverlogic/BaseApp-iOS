//
//  ProcessInfo+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/23/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

extension ProcessInfo {
    
    /// Determines if the application is running unit tests.
    static var isRunningUnitTests: Bool {
        let environmentDictionary = processInfo.environment
        return environmentDictionary["RUNNING_UNIT_TESTS"] == "TRUE"
    }
    
    /// Determines if the application is running integration tests.
    static var isRunningIntegrationTests: Bool {
        let environmentDictionary = processInfo.environment
        return environmentDictionary["RUNNING_INTEGRATION_TESTS"] == "TRUE"
    }
}
