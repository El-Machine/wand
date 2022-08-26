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

public func |<C: Sequence, T> (p: C, handler: @escaping (C.Element) throws -> T) -> [T] {
    try! p.map(handler)
}

public func |<C: Sequence> (p: C, handler: @escaping (C.Element) throws -> Bool) -> [C.Element] {
    try! p.filter(handler)
}

//forEach
public func |<C: Sequence> (p: C?, handler: @escaping (C.Element) throws -> Void) {
    try? p?.forEach(handler)
}

public func |<C: Sequence> (p: C?, handler: @escaping () throws -> Void) {
    p?.forEach { _ in
        try? handler()
    }
}

//first
public func |<C: Sequence> (p: C?, handler: @escaping (C.Element) throws -> Bool) -> C.Element? {
    try? p?.first(where: handler)
}

public func |<C: Sequence, T> (p: C,
                        to: (initial: T, next: (T, C.Element) throws -> T)) -> T {
    try! p.reduce(to.initial, to.next)
}
