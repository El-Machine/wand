//
//  Range_any.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation

public extension ClosedRange where Bound: FixedWidthInteger {

    var any: Bound {
        .random(in: self)
    }

}
