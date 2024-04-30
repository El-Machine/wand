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

#if canImport(CoreMotion) && !targetEnvironment(simulator) && !os(macOS)
import CoreMotion

import Wand
import XCTest

class CoreMotion_Tests: XCTestCase {


    func test_CMPedometerEvent() {
        let e = expectation()
        e.assertForOverFulfill = false

        |.one { (event: CMPedometerEvent) in
            e.fulfill()
        }

        waitForExpectations()
    }

    //Test it while walking
//    func test_CMPedometerData() {
//        let e = expectation()
//
//        |{ (location: CMPedometerData) in
//            e.fulfill()
//        }
//
//        waitForExpectations()
//    }

    func test_CMPedometer() {
        XCTAssertNotNil(CMPedometer.self|)
    }
}

#endif
