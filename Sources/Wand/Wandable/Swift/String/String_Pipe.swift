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

//Description
public
postfix func |(piped: Any) -> String {
    String(describing: piped)
}

public
postfix func |<T: LosslessStringConvertible>(p: T?) -> String {
    guard let piped = p else {
        return ""
    }

    return String(piped)
}

//Data
public
postfix func |(data: Data) -> String {
    String(data: data, encoding: .utf8)!
}

public
postfix func |(data: Data) -> String? {
    String(data: data, encoding: .utf8)
}

public
postfix func |(data: Data?) -> String {
    guard let data else {
        fatalError()
    }
    return String(data: data, encoding: .utf8)!
}

public
postfix func |(data: Data?) -> String? {
    guard let data else {
        return nil
    }
    return String(data: data, encoding: .utf8)
}

extension Substring {

    public static prefix func |(sub: Substring) -> String {
        String(sub)
    }

}

public prefix func |(self: String?) -> String {
    self ?? ""
}

public func |(p: String?, filtering: CharacterSet) -> String? {
    guard let piped = p else {
        return nil
    }

    return (piped | filtering) as String
}

public func |(p: String, filtering: CharacterSet) -> String {
    String(p.unicodeScalars.filter {
        filtering.contains($0)
    })
}

public func |(p: String, replace: (bounds: Range<String.Index>, to: String)) -> String {
    var piped = p
    piped.replaceSubrange(replace.0, with: replace.1)
    return piped
}

public func |(p: String, replace: (ClosedRange<String.Index>, String)) -> String {
    var piped = p
    piped.replaceSubrange(replace.0, with: replace.1)
    return piped
}

public func |(p: String, range: NSRange) -> String {
    let from = p.index(p.startIndex, offsetBy: range.lowerBound)
    let to = p.index(p.startIndex, offsetBy: range.upperBound)

    return p | (from..<to)
}

postfix func |(piped: NSRange) -> Range<Int> {
    Range(uncheckedBounds: (piped.lowerBound, piped.upperBound))
}

public func |(p: String, range: NSRange) -> Range<String.Index> {
    let from = p.index(p.startIndex, offsetBy: range.lowerBound)
    let to = p.index(p.startIndex, offsetBy: range.upperBound)

    return (from..<to)
}

public func |(piped: String, replace: (bounds: NSRange, to: String)) -> String {
    var string = piped

    let range: Range<String.Index> = string | replace.bounds
    string.replaceSubrange(range, with: replace.to)
    return string
}

//Components
public
func |(piped: String?, separator: any StringProtocol) -> [String]? {
    piped?.components(separatedBy: separator)
}

func |(piped: String, separator: any StringProtocol) -> [String] {
    piped.components(separatedBy: separator)
}

//public func |(format: String, arguments: CVarArg...) -> String {
//
//}
