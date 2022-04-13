//  Copyright © 2020-2022 Alex Kozin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2022 Alex Kozin
//

import Foundation

postfix func |(p: Data) -> String {
    String(data: p, encoding: .utf8)!
}

func |(p: Data, encoding: String.Encoding) -> String {
    String(data: p, encoding: encoding)!
}

postfix func |(p: Data?) -> String {
    guard let piped = p else {
        return ""
    }
    return String(data: piped, encoding: .utf8)!
}

func |(p: Data?, encoding: String.Encoding) -> String {
    guard let piped = p else {
        return ""
    }
    return String(data: piped, encoding: encoding)!
}

postfix func |<T: LosslessStringConvertible>(p: T?) -> String {
    guard let piped = p else {
        return ""
    }

    return String(piped)
}

postfix func |<T>(p: T?) -> String {
    guard let piped = p else {
        return ""
    }

    return String(describing: piped)
}

postfix func |<T>(p: T) -> String {
    String(describing: p)
}

extension Substring {

    static prefix func |(sub: Substring) -> String {
        String(sub)
    }

}

prefix func |(self: String?) -> String {
    self ?? ""
}

func |(p: String?, filtering: CharacterSet) -> String? {
    guard let piped = p else {
        return nil
    }

    return (piped | filtering) as String
}

func |(p: String, filtering: CharacterSet) -> String {
    String(p.unicodeScalars.filter {
        !filtering.contains($0)
    })
}

//NSTextCheckingResult
func |(p: String?, type: NSTextCheckingResult.CheckingType) -> String? {
    switch type {
        case .phoneNumber:
            return match(p, type)?.phoneNumber
        default:
            return nil
    }
}

func |(p: String?, type: NSTextCheckingResult.CheckingType) -> [NSTextCheckingKey : String]? {
    switch type {
        case .address:
            return match(p, type)?.addressComponents
        default:
            return nil
    }
}

func |(p: String?, type: NSTextCheckingResult.CheckingType) -> Date? {
    switch type {
        case .date:
            return match(p, type)?.date
        default:
            return nil
    }

}

func |(p: String?, type: NSTextCheckingResult.CheckingType) -> TimeInterval? {
    switch type {
        case .date:
            return match(p, type)?.duration
        default:
            return nil
    }
}

func |(p: String?, type: NSTextCheckingResult.CheckingType) -> TimeZone? {
    switch type {
        case .date:
            return match(p, type)?.timeZone
        default:
            return nil
    }
}

fileprivate func match(_ p: String?, _ type: NSTextCheckingResult.CheckingType) -> NSTextCheckingResult? {
    guard let piped = p else {
        return nil
    }

    let detector = try! NSDataDetector(types: type.rawValue)
    return detector.firstMatch(in: piped,
                               options: [],
                               range: (0, piped.count)|)
}

//Substring
func |(p: String, range: PartialRangeThrough<String.IndexDistance>) -> String {
    String(p.suffix(range.upperBound))
}

func |(p: String, range: PartialRangeFrom<String.IndexDistance>) -> String {
    String(p.prefix(range.lowerBound))
}

func |(p: String, range: Range<String.IndexDistance>) -> String {
    let from = p.index(p.startIndex, offsetBy: range.lowerBound)
    let to = p.index(p.startIndex, offsetBy: range.upperBound)

    return p | (from..<to)
}

func |(p: String, range: Range<String.Index>) -> String {
    String(p[range])
}

//Replace
func |(p: String, replace: (bounds: Range<String.IndexDistance>, to: String)) -> String {
    let from = p.index(p.startIndex, offsetBy: replace.bounds.lowerBound)
    let to = p.index(p.startIndex, offsetBy:  replace.bounds.upperBound)

    return p | (bounds: from..<to, to: replace.to)
}

func |(p: String, replace: (bounds: Range<String.Index>, to: String)) -> String {
    var piped = p
    piped.replaceSubrange(replace.0, with: replace.1)
    return piped
}

func |(p: String, replace: (ClosedRange<String.Index>, String)) -> String {
    var piped = p
    piped.replaceSubrange(replace.0, with: replace.1)
    return piped
}

func |(p: String, range: NSRange) -> String {
    let from = p.index(p.startIndex, offsetBy: range.lowerBound)
    let to = p.index(p.startIndex, offsetBy: range.upperBound)

    return p | (from..<to)
}

postfix func |(piped: NSRange) -> Range<Int> {
    Range(uncheckedBounds: (piped.lowerBound, piped.upperBound))
}

func |(p: String, range: NSRange) -> Range<String.Index> {
    let from = p.index(p.startIndex, offsetBy: range.lowerBound)
    let to = p.index(p.startIndex, offsetBy: range.upperBound)

    return (from..<to)
}

func |(piped: String, replace: (bounds: NSRange, to: String)) -> String {
    var string = piped

    let range: Range<String.Index> = string | replace.bounds
    string.replaceSubrange(range, with: replace.to)
    return string
}

//Regex
func |(p: String, pattern: String) -> [NSTextCheckingResult]? {
    try? NSRegularExpression(pattern: pattern, options: [])
        .matches(in: p, options: [], range: (0, p.count)|)
}

func |(p: String, pattern: String) -> NSTextCheckingResult? {
    (p | pattern)?.first
}
