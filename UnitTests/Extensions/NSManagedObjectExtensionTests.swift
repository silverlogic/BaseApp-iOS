//
//  NSManagedObjectExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
@testable import Development
import XCTest

final class NSManagedObjectExtensionTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testEntityName() {
        XCTAssertEqual(NSManagedObject.entityName, "NSManagedObject", "Incorrect Format!")
        XCTAssertEqual(User.entityName, "User", "Incorrect Format!")
    }
}
