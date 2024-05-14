///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) .LICENSE
/// 2) https://apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
/// Created by Alex Kozin
/// 2020 El Machine

import Foundation

import Wand
import XCTest

class Expect_Any_Tests: XCTestCase {

    func test_Any() throws {
        let e = expectation(description: "event.any")
        e.assertForOverFulfill = false

        let wand = Point.every | String.every | .any { _ in
            e.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak wand] in

            if .random() {
                wand?.add(Point.any)
            } else {
                wand?.add(String.any)
            }

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

extension String: Asking
{
    public static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {
        _ = wand.answer(the: ask)
    }


}
