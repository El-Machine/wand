/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

import Contacts
import CoreLocation
import CoreMotion

import Wand
import XCTest

class Expect_Any_Tests: XCTestCase {

    func test_Any() throws {
        let e = expectation(description: "event.any")
        e.assertForOverFulfill = false

        CLLocation.every | CMPedometerEvent.every | .any {
            print("Every " + $0|)
            e.fulfill()
        }

        waitForExpectations()
    }

    //Works in Debug and Prod
//    func test_All() throws {
//        let e = expectation(description: "event.any")
//        e.expectedFulfillmentCount = 2
//
//        weak var wand: Wand!
//        wand = CLLocation.one | CNContact.one | .all {
//
//            if let piped: CLLocation = wand.get() {
//                e.fulfill()
//            }
//
//            if let piped: CMPedometerEvent = wand.get() {
//                e.fulfill()
//            }
//
//        }
//
//        waitForExpectations()
//    }


}
