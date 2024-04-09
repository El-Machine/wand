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

import Foundation.NSTextCheckingResult

import Wand
import XCTest

class NSTextCheckingResultCheckingType_Tests: XCTestCase {

    @available(iOS 15, *)
    func test_NSTextCheckingResult_date() {
        let hour = Int.any(in: 0...24)

        let found: Date? = "tomorrow at \(hour) UTC+4" | .date

        //Check equality
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day, .month, .year, .hour], from: .now)
        components.day = components.day! + 1
        components.hour = hour
        components.timeZone = TimeZone(identifier: "UTC+4")

        let calculated = Calendar.current.date(from: components)

        XCTAssertEqual(found, calculated)
    }

    func test_NSTextCheckingResult_address() {
        let found: [NSTextCheckingKey: String]? = "1 Infinite Loop in Cupertino, California, United States" | .address

        //Check equality
        let calculated = [NSTextCheckingKey.state: "California",
                          NSTextCheckingKey.city: "Cupertino",
                          NSTextCheckingKey.street: "1 Infinite Loop",
                          NSTextCheckingKey.country: "United States"]
        XCTAssertEqual(found, calculated)
    }

    func test_NSTextCheckingResult_url() {
        let found: URL? = "1 Infinite Loop in Cupht//www.apple.com California, United States" | .link

        //Check equality
        let calculated = URL(string: "http://www.apple.com")
        XCTAssertEqual(found, calculated)
    }

    func test_NSTextCheckingResult_phoneNumber() {
        let found: String? = "1 Inffornia +19323232444,United States" | .phoneNumber

        //Check equality
        let calculated = "+19323232444"
        XCTAssertEqual(found, calculated)
    }

}
