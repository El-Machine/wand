//
//  Event_Tests.swift
//  toolburator_Tests
//
//  Created by Alex Kozin on 29.04.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CoreLocation
import CoreMotion

import Pipe
import XCTest

class Expect_Any_Tests: XCTestCase {

#if !targetEnvironment(simulator)

    func test_Any() throws {
        let e = expectation(description: "event.any")
        e.assertForOverFulfill = false

        CLLocation.every | CMPedometerEvent.every | .any {
            print("Every " + $0|)
            e.fulfill()
        }

        waitForExpectations()
    }

    func test_All() throws {
        let e = expectation(description: "event.any")
        e.expectedFulfillmentCount = 2

        var pipe: Pipeline!
        pipe = (CLLocation.one | CMPedometerEvent.one | .all { _ in

            if let piped: CLLocation = pipe.get() {
                e.fulfill()
            }

            if let piped: CMPedometerEvent = pipe.get() {
                e.fulfill()
            }

        })

        waitForExpectations()
    }

#endif

}
