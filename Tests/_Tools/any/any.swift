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

import Foundation
import CoreFoundation

protocol Any_ {

    static var any: Self {get}

}

protocol BoundedAny: Any_ where Self: Comparable {


    static var min: Self { get }
    static var max: Self { get }

    static func any(in bounds: ClosedRange<Self>) -> Self
    static func any(in array: [Self]) -> Self

}

extension BoundedAny {

    static var any: Self {
        .any(in: (.min)...(.max))
    }

    static func any(in array: [Self]) -> Self {
        array.randomElement()!
    }

}

extension FixedWidthInteger {

    static var any: Self {
        .random(in: (.min)...(.max))
    }

    static func any(in bounds: ClosedRange<Self>) -> Self {
        .random(in: bounds)
    }

}

extension Float: BoundedAny {

    static var min: Self {
        .leastNormalMagnitude
    }

    static var max: Self {
        .greatestFiniteMagnitude
    }

    static func any(in bounds: ClosedRange<Self>) -> Self {
        .random(in: bounds)
    }

}

extension Double: BoundedAny {

    static var min: Self {
        .leastNormalMagnitude
    }

    static var max: Self {
        .greatestFiniteMagnitude
    }

    static func any(in bounds: ClosedRange<Self>) -> Self {
        .random(in: bounds)
    }

}

//extension CGFloat: BoundedAny {
//
//    static var min: Self {
//        .leastNormalMagnitude
//    }
//
//    static var max: Self {
//        .greatestFiniteMagnitude
//    }
//
//    static func any(in bounds: ClosedRange<Self>) -> Self {
//        .random(in: bounds)
//    }
//
//}

extension Date: Any_ {

    static var any: Self {
        Date(timeIntervalSince1970: .any(in: 0...(Date.distantFuture.timeIntervalSince1970)))
    }

}
