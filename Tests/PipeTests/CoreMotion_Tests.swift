//
//  CMPedometer+Pipe_Tests.swift
//  Sample
//
//  Created by Alex Kozin on 09.11.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import XCTest

import CoreMotion

class CoreMotion_Tests: XCTestCase {

    func testPedometerEvent() {
        let e = expectation(description: "testPedometerEvent")
        
        |{ (event: CMPedometerEvent) in
            e.fulfill()
        }
        
        waitForExpectations(timeout: 3)
        XCTAssertTrue(e.assertForOverFulfill)
    }
    
    func testPedometerData() {
        let e = expectation(description: "PedometerData")
        
        |{ (data: CMPedometerData) in
            e.fulfill()
        }
        
        waitForExpectations(timeout: 20)
        XCTAssertTrue(e.assertForOverFulfill)
    }
    
    func testPedometerDataAndEvent() {
        let e = expectation(description: "PedometerDataAndEvent")
        e.expectedFulfillmentCount = 2
        
        |{ (event: CMPedometerEvent) in
            e.fulfill()
        } | { (data: CMPedometerData) in
            e.fulfill()
        }
        
        waitForExpectations(timeout: 20)
        XCTAssertTrue(e.assertForOverFulfill)
    }

}
