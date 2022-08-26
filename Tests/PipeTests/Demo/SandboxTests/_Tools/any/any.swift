//
//  any.swift
//  toolburator
//
//  Created by Alex Kozin on 17.05.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

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
