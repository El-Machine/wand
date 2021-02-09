//
//  CoreLocation+Tests.swift
//  SampleTests
//
//  Created by Alex Kozin on 13.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import XCTest

import CoreLocation

class CoreLocation_Tests: XCTestCase {

    func testLocation() {
        let e = expectation(description: "event")
        
        |{ (location: CLLocation) in
            e.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertTrue(e.assertForOverFulfill)
    }
    

}
