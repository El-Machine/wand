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

import CoreLocation.CLLocation

import Wand
import XCTest

class Wand_Tests: XCTestCase {

    weak var wand: Wand?

    func test_put() throws {
        let pipe = Wand()
        self.wand = pipe

        let struct_ = CLLocationCoordinate2D.any
        pipe.add(struct_)

        let custom_struct = Custom(foo: .any)
        pipe.add(custom_struct)

        let class_ = pipe.add(CLLocation.any)

        let custom_class = CustomClass()
        custom_class.foo = .any
        pipe.add(custom_class)

        // piped equals original
        let piped_struct: CLLocationCoordinate2D = try XCTUnwrap(pipe.get())
        XCTAssertTrue(struct_.latitude == piped_struct.latitude &&
                      struct_.longitude == piped_struct.longitude)

        let piped_custom_struct: Custom = try XCTUnwrap(pipe.get())
        XCTAssertTrue(custom_struct.foo == piped_custom_struct.foo)

        XCTAssertEqual(class_, pipe.get())

        let piped_custom_class: CustomClass = try XCTUnwrap(pipe.get())
        XCTAssertIdentical(custom_class, piped_custom_class)

        pipe.close()
    }

    func test_putWanded() throws {
        let wand = Wand()
        self.wand = wand

        let original = CLLocation(latitude: (-90...90)|,
                                  longitude: (-180...180)|)
        wand.add(original)

        // piped equals original
        let piped: CLLocation = try XCTUnwrap(wand.get())
        XCTAssertEqual(original, piped)

        // pipe is same
        XCTAssertTrue(wand === piped.wand)
        XCTAssertTrue(original.wand === piped.wand)

        wand.close()
    }

    func test_closed() throws {
        XCTAssertNil(wand)
    }


    private struct Custom {
        var foo: Int
    }

    private class CustomClass {
        var foo: Int?
    }

}
