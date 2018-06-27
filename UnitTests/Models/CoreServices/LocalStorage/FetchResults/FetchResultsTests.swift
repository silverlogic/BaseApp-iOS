//
//  FetchResultsTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/20/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import CoreData
@testable import Development
import XCTest

final class FetchResultsTests: BaseUnitTests {
    
    // MARK: - Functional Tests
    func testFetchResultsInstance() {
        // swiftlint:disable line_length
        guard let fetchRequest = User.allUsersFetchRequest(keyPath: #keyPath(User.userId),
                                                           ascending: true) as? NSFetchRequest<NSFetchRequestResult>,
              let fetchResults = FetchResults(with: fetchRequest,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil) else {
                XCTFail("Error Initializing Instance!")
                return
        }
        // swiftlint:enable line_length
        let itemInsertedExpectation = expectation(description: "Test Inserting Listener")
        let itemDeletedExpectation = expectation(description: "Test Deleted Listerner")
        let itemUpdatedExpectation = expectation(description: "Test Uodating Listener")
        let insertExpectation = expectation(description: "Test Inserting")
        let deleteExpectation = expectation(description: "Test Deleting")
        let updateExpectation = expectation(description: "Test Updating")
        fetchResults.itemInserted.bind { _ in
            itemInsertedExpectation.fulfill()
        }
        fetchResults.itemDeleted.bind { _ in
            itemDeletedExpectation.fulfill()
        }
        fetchResults.itemUpdated.bind { _ in
            itemUpdatedExpectation.fulfill()
        }
        fetchResults.fetchError.bind { _ in
            XCTFail("Error Fetching Objects!")
            itemInsertedExpectation.fulfill()
            itemDeletedExpectation.fulfill()
            itemUpdatedExpectation.fulfill()
            insertExpectation.fulfill()
            deleteExpectation.fulfill()
            updateExpectation.fulfill()
        }
        fetchResults.beginFetchingObjects()
        XCTAssertTrue(fetchResults.numberOfObjects() > 0, "Fetching Objects Failed!")
        XCTAssertNotNil(fetchResults.numberOfSections(), "Value Shouldn't Be Nil!")
        XCTAssertNotNil(fetchResults.numberOfRowsForSection(0), "Value Shouldn't Be Nil!")
        guard let _: User = fetchResults.itemAtIndexPath(IndexPath(row: 0, section: 0)) else {
            XCTFail("Fetching Object Failed!")
            return
        }
        CoreDataStack.shared.insertObject(for: User.self, success: { (user: User) in
            user.firstName = "Bubba"
            CoreDataStack.shared.saveCurrentState(success: {
                CoreDataStack.shared.deleteObject(user, success: { 
                    deleteExpectation.fulfill()
                }, failure: { 
                    XCTFail("Error Updating Object!")
                    itemDeletedExpectation.fulfill()
                    deleteExpectation.fulfill()
                })
                updateExpectation.fulfill()
            }, failure: { 
                XCTFail("Error Updating Object!")
                itemDeletedExpectation.fulfill()
                itemUpdatedExpectation.fulfill()
                deleteExpectation.fulfill()
                updateExpectation.fulfill()
            })
            insertExpectation.fulfill()
        }) { 
            XCTFail("Error Inserting Object!")
            itemInsertedExpectation.fulfill()
            itemDeletedExpectation.fulfill()
            itemUpdatedExpectation.fulfill()
            insertExpectation.fulfill()
            deleteExpectation.fulfill()
            updateExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
