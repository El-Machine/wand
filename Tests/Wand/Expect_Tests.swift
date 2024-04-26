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

import CoreLocation
import CoreMotion

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

            print(count)
            i = i+1
        }

        waitForExpectations(timeout: .default)

        wand.close()
        //TODO: Fix
        //XCTAssertNil(wand)
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
