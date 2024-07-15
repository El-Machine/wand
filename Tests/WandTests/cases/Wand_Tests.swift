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
import CoreLocation.CLLocation

import Wand
import XCTest

class Wand_Tests: XCTestCase {

    weak var wand: Wand?

    func test_put() throws {
        let wand = Wand()
        self.wand = wand

        let struct_ = CLLocationCoordinate2D.any
        wand.add(struct_)

        let custom_struct = Custom(bar: .any)
        wand.add(custom_struct)

        let class_ = wand.add(CLLocation.any)

        let custom_class = CustomClass()
        custom_class.bar = .any
        wand.add(custom_class)

        // wanded equals original
        let wanded_struct: CLLocationCoordinate2D = try XCTUnwrap(wand.get() )
        XCTAssertTrue(struct_.latitude == wanded_struct.latitude &&
                      struct_.longitude == wanded_struct.longitude)

        let wanded_custom_struct: Custom = try XCTUnwrap(wand.get())
        XCTAssertTrue(custom_struct.bar == wanded_custom_struct.bar)

        XCTAssertEqual(class_, wand.get())

        let wanded_custom_class: CustomClass = try XCTUnwrap(wand.get())
        XCTAssertIdentical(custom_class, wanded_custom_class)

        wand.close()
    }

    func test_putWanded() throws {
        let wand = Wand()
        self.wand = wand

        let original: CLLocation = CLLocation.any
        wand.add(original)

        // wanded equals original
        let wanded: CLLocation = try XCTUnwrap(wand.get())
        XCTAssertEqual(original, wanded)

        // wand is the same
        XCTAssertTrue(wand === (wanded as Optional).wend)
        XCTAssertTrue((original as Optional).wend === 
                      (wanded as Optional).wend)

        wand.close()
    }

    func test_closed() throws {
        XCTAssertNil(wand)
    }

    private 
    struct Custom {
        var bar: Int
    }

    private 
    class CustomClass {
        var bar: Int?
    }

}
