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


public func | (date: Date?, style: (date: DateFormatter.Style,
                                    time: DateFormatter.Style)) -> String? {

    guard let date else {
        return nil
    }

    let formatter: DateFormatter = style|
    return formatter.string(from: date)
}

//Format
public func | (date: Date?, format: String) -> String? {
    guard let date else {
        return nil
    }

    let formatter: DateFormatter = format|
    return formatter.string(from: date)
}

//DateFormatter
extension DateFormatter: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let formatter = Self()

        //TODO: both if is required?
        if let style: (date: DateFormatter.Style,
                       time: DateFormatter.Style) = pipe.get() {

            formatter.dateStyle = style.0
            formatter.timeStyle = style.1

            return formatter
        }

        if let format: String = pipe.get() {
            formatter.dateFormat = format

            return formatter
        }

        return formatter

    }

}

//Shortcuts
public postfix func | (style: (date: DateFormatter.Style,
                               time: DateFormatter.Style)) -> DateFormatter {

    let formatter = DateFormatter()
    formatter.dateStyle = style.0
    formatter.timeStyle = style.1

    return formatter
}

public postfix func | (format: String) -> DateFormatter {

    let formatter = DateFormatter()
    formatter.dateFormat = format

    return formatter
}

public func | (formatter: DateFormatter, date: Date?) -> String? {

    guard let date else {
        return nil
    }

    return formatter.string(from: date)
}
