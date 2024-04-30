//
//  String.IndexDistance_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 26.09.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

//Substring
public func |(p: String, range: PartialRangeThrough<Int>) -> String {
    String(p.suffix(range.upperBound))
}

public func |(p: String, range: PartialRangeFrom<Int>) -> String {
    String(p.prefix(range.lowerBound))
}

public func |(p: String, range: Range<Int>) -> String {
    let from = p.index(p.startIndex, offsetBy: range.lowerBound)
    let to = p.index(p.startIndex, offsetBy: range.upperBound)

    return p | (from..<to)
}

public func |(p: String, range: Range<String.Index>) -> String {
    String(p[range])
}

//Replace
public func |(p: String, replace: (bounds: Range<Int>, to: String)) -> String {
    let from = p.index(p.startIndex, offsetBy: replace.bounds.lowerBound)
    let to = p.index(p.startIndex, offsetBy:  replace.bounds.upperBound)

    return p | (bounds: from..<to, to: replace.to)
}

public func |(piped: String?, range: PartialRangeFrom<Int>?) -> (String, String)? {
    piped == nil || range == nil ? nil
    : piped! | range!
}

public func |(piped: String, range: PartialRangeFrom<Int>) -> (String, String) {
    (String(piped.prefix(range.lowerBound)), String(piped.suffix(piped.count - range.lowerBound)))
}
