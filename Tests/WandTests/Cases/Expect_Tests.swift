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

class Expect_T_Tests: XCTestCase {

    func test_Every() throws {
        //Insert 'count' times
        let count: Int = .any(in: 1...22)

        let e = expectation()
        e.expectedFulfillmentCount = count

        var last: Point?

        //Wait for 'count' Points
        weak var wand: Wand!
        wand = |.every { (point: Point) in
            //Is equal?
            if point == last {
                e.fulfill()
            }
        }

        //Put for 'count' Points
        var i = 0
        (0..<count).forEach { _ in
            let point = Point.any
            last = point

            wand.add(point)

            i = i+1
        }

        waitForExpectations(timeout: .default)

        wand.close()
    }

    func test_One() throws {
        let e = expectation()

        let point = Point.any

        weak var wand: Wand!
        wand = |.one { (point: Point) in
            e.fulfill()
        }

        wand.add(point)

        waitForExpectations()
        XCTAssertNil(wand)
    }

    func test_While() throws {

        func put() {
            DispatchQueue.main.async {
                wand.add(Point.any)
            }
        }

        let e = expectation()

        weak var wand: Wand!
        wand = |.while { (point: Point) in

            if point.id == 2 {
                e.fulfill()
                return false
            } else {
                put()
                return true
            }

        }

        put()

        waitForExpectations()
        XCTAssertNil(wand)
    }

}
