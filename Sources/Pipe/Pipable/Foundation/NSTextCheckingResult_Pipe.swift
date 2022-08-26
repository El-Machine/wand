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

import Foundation.NSTextCheckingResult

public prefix func |(piped: (NSTextCheckingResult)->() ) {
    print(
        """
            | usage

            let date: Date? = "tomorrow at 8 UTC+4" | .date

            let address: [NSTextCheckingKey: String]? = "1 InfiniteLoop in Cupertino" | .address

            let url: URL? = "1 Infiupht//www.apple.com California, United" | .link

            let phoneNumber: String? = "1 Inffornia +19323232444,States" | .phoneNumber
        """
    )
}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> NSOrthography? {
    switch type {
        case .date:
            return match(piped, type)?.orthography
        default:
            return nil
    }
}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> Date? {
    switch type {
        case .date:
            return match(piped, type)?.date
        default:
            return nil
    }

}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> TimeInterval? {
    switch type {
        case .date:
            return match(piped, type)?.duration
        default:
            return nil
    }
}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> [NSTextCheckingKey: String]? {
    switch type {
        case .address:
            return match(piped, type)?.addressComponents
        default:
            return nil
    }

}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> URL? {
    switch type {
        case .link:
            return match(piped, type)?.url
        default:
            return nil
    }
}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> String? {
    switch type {
        case .phoneNumber:
            return match(piped, type)?.phoneNumber
        default:
            return nil
    }
}

public func |(piped: String?, type: NSTextCheckingResult.CheckingType) -> TimeZone? {
    switch type {
        case .date:
            return match(piped, type)?.timeZone
        default:
            return nil
    }
}

fileprivate func match(_ piped: String?,
                       _ type: NSTextCheckingResult.CheckingType) -> NSTextCheckingResult? {
    guard let piped = piped else {
        return nil
    }

    let detector = try! NSDataDetector(types: type.rawValue)
    return detector.firstMatch(in: piped,
                               options: [],
                               range: (0, piped.count)|)
}

public func |(p: String, pattern: String) -> [NSTextCheckingResult]? {
    try? NSRegularExpression(pattern: pattern, options: [])
        .matches(in: p, options: [], range: (0, p.count)|)
}

public func |(p: String, pattern: String) -> NSTextCheckingResult? {
    (p | pattern)?.first
}
