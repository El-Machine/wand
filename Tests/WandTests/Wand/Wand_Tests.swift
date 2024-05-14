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

//import CoreLocation.CLLocation
//
//import Wand
//import XCTest
//
//class Wand_Tests: XCTestCase {
//
//    weak var wand: Wand?
//
//    func test_put() throws {
//        let pipe = Wand()
//        self.wand = pipe
//
//        let struct_ = CLLocationCoordinate2D.any
//        pipe.add(struct_)
//
//        let custom_struct = Custom(foo: .any)
//        pipe.add(custom_struct)
//
//        let class_ = pipe.add(CLLocation.any)
//
//        let custom_class = CustomClass()
//        custom_class.foo = .any
//        pipe.add(custom_class)
//
//        // piped equals original
//        let piped_struct: CLLocationCoordinate2D = try XCTUnwrap(pipe.get())
//        XCTAssertTrue(struct_.latitude == piped_struct.latitude &&
//                      struct_.longitude == piped_struct.longitude)
//
//        let piped_custom_struct: Custom = try XCTUnwrap(pipe.get())
//        XCTAssertTrue(custom_struct.foo == piped_custom_struct.foo)
//
//        XCTAssertEqual(class_, pipe.get())
//
//        let piped_custom_class: CustomClass = try XCTUnwrap(pipe.get())
//        XCTAssertIdentical(custom_class, piped_custom_class)
//
//        pipe.close()
//    }
//
//    func test_putWanded() throws {
//        let wand = Wand()
//        self.wand = wand
//
//        let original = CLLocation(latitude: (-90...90)|,
//                                  longitude: (-180...180)|)
//        wand.add(original)
//
//        // piped equals original
//        let piped: CLLocation = try XCTUnwrap(wand.get())
//        XCTAssertEqual(original, piped)
//
//        // pipe is same
//        XCTAssertTrue(wand === piped.wand)
//        XCTAssertTrue(original.wand === piped.wand)
//
//        wand.close()
//    }
//
//    func test_closed() throws {
//        XCTAssertNil(wand)
//    }
//
//
//    private struct Custom {
//        var foo: Int
//    }
//
//    private class CustomClass {
//        var foo: Int?
//    }
//
//}
