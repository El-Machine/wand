//  Copyright © 2020-2022 El Machine 🤖
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
//

import Foundation

//Data
postfix func |(p: Data) -> String {
    String(data: p, encoding: .utf8)!
}

postfix func |(p: Data) -> String? {
    String(data: p, encoding: .utf8)
}

postfix func |(p: Data?) -> String? {
    guard let piped = p else {
        return nil
    }
    return String(data: piped, encoding: .utf8)
}

//Data String.Encoding
func |(p: Data, encoding: String.Encoding) -> String {
    String(data: p, encoding: encoding)!
}


func |(p: Data?, encoding: String.Encoding) -> String {
    guard let piped = p else {
        return ""
    }
    return String(data: piped, encoding: encoding)!
}


func |(p: Data?, encoding: String.Encoding) -> String? {
    guard let piped = p else {
        return nil
    }
    return String(data: piped, encoding: encoding)
}

//Description
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

func |(piped: String?, range: PartialRangeFrom<String.IndexDistance>?) -> (String, String)? {
    piped == nil || range == nil ? nil
    : piped! | range!
}

func |(piped: String, range: PartialRangeFrom<String.IndexDistance>) -> (String, String) {
    (String(piped.prefix(range.lowerBound)), String(piped.suffix(piped.count - range.lowerBound)))
}
