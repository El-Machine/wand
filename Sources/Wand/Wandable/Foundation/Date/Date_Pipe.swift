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

extension Date {

    static public postfix func |(piped: Date.Type) -> Int {
        Int(Date().timeIntervalSince1970)
    }

    static public postfix func |(piped: Date.Type) -> TimeInterval {
        Date().timeIntervalSince1970
    }

}

public postfix func |(piped: TimeInterval) -> Date {
    Date(timeIntervalSince1970: piped)
}

public postfix func |(piped: Int) -> Date {
    Date(timeIntervalSince1970: TimeInterval(piped))
}

//DateComponents
public postfix func | (piped: DateComponents) -> Date? {
    Calendar.current.date(from: piped)
}

public postfix func |(date: Date) -> String? {

    let formatted: String?

    if Calendar.current.isDateInToday(date) {
        formatted = date | "HH:mm"
    } else {
        formatted = date | "dd.MM HH:mm"
    }


    return formatted
}


