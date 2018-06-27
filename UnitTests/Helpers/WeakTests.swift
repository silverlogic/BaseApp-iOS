//
//  WeakTests.swift
//  BaseAppV2
//
//  Created by Vasilii Muravev on 5/1/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

@testable import Development
import XCTest

class WeakTests: BaseUnitTests {
    
    func testWeak() {
        let weakWeak = Weak(NSObject())
        XCTAssertNil(weakWeak.value, "Value Should Be Nil!")
        let strongValue = NSObject()
        let weakStrong = Weak(strongValue)
        XCTAssertNotNil(weakStrong.value, "Value Should Not Be Nil!")
    }
}
