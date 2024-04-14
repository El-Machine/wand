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

import Vision

import Wand
import XCTest

class Vision_Tests: XCTestCase {

    func test_Face() {
        let e = expectation()
        e.assertForOverFulfill = false

        |.every { (face: VNFaceObservation) in
            e.fulfill()
        }

        waitForExpectations()
    }

//    func test_CLLocation_options() {
//        let e = expectation()
//        e.assertForOverFulfill = false
//
//        let accuracy = CLLocationAccuracy.any(in: [
//            kCLLocationAccuracyBestForNavigation,
//            kCLLocationAccuracyBest,
//            kCLLocationAccuracyNearestTenMeters,
//            kCLLocationAccuracyHundredMeters,
//            kCLLocationAccuracyKilometer,
//            kCLLocationAccuracyThreeKilometers
//        ])
//        let distance = ((100...420)| as Int)| as Double
//
//        let pipe: Wand = ["CLLocationAccuracy": accuracy,
//                              "CLLocationDistance": distance]
//        let piped = pipe.context
//
//        pipe | .one { (location: CLLocation) in
//            e.fulfill()
//        }
//
//
//        let manager: CLLocationManager = pipe.obtain()
//        XCTAssertEqual(manager.desiredAccuracy,
//                       piped["CLLocationAccuracy"] as! CLLocationAccuracy)
//        XCTAssertEqual(manager.distanceFilter,
//                       piped["CLLocationDistance"] as! CLLocationDistance)
//
//        waitForExpectations()
//    }
//
//    func test_CLAuthorizationStatus() {
//        let e = expectation()
//        e.assertForOverFulfill = false
//
//        |.one { (status: CLAuthorizationStatus) in
//            e.fulfill()
//        }
//
//        waitForExpectations()
//    }
//
//    func test_CLLocationManager() {
//        XCTAssertNotNil(self| as CLLocationManager)
//    }

}
