//
//  NetworkClientTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

final class NetworkClientTests: BaseUnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let client = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl,
                                   manageObjectContext: CoreDataStack.shared.managedObjectContext)
        XCTAssertNotNil(client, "Value Should Not Be Nil!")
        XCTAssertEqual(client.baseURL, ConfigurationManager.shared.apiUrl, "Should be equal!")
        XCTAssertEqual(client.context, CoreDataStack.shared.managedObjectContext, "Should be equal!")
    }
}
