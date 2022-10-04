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

protocol Expecting {

    var isInner: Bool {get}

    func handle(_ object: Any) -> Bool

}

/// Pipe.Expect
/// Expecting instance of E
///
/// Will call `handler` when E will be putted to pipe.
///  - `every`  time
///  - `one`    only
///  - `while`  returns true
///
public final class Expect<T>: Expecting {
    
    enum Condition {

        case every, one, `while`,
             all, any

    }

    typealias Handler = (T)->(Bool)

    let with: Any?
    let condition: Condition

    let handler: Handler
    public var cleaner: ( ()->() )?

    private(set) var isInner = false
    public func inner() -> Expect<T> {
        isInner = true
        return self
    }

    func handle(_ object: Any) -> Bool {
        handler(object as! T)
    }

    internal required init(with: Any? = nil,
                           condition: Condition,
                           isInner: Bool = false,
                           handler: @escaping Handler) {
        self.with = with
        self.condition = condition
        self.isInner = isInner
        self.handler = handler
    }

    //Event
    public static func every(_ handler: ((T)->() )? = nil) -> Self {
        Self(condition: .every) {
            handler?($0)
            return true
        }
    }
    
    public static func one(_ handler: ((T)->() )? = nil) -> Self {
        Self(condition: .one) {
            handler?($0)
            return false
        }
    }

    public static func `while`(_ handler: @escaping (T)->(Bool) ) -> Self {
        Self(condition: .while, handler: handler)
    }

    deinit {
        cleaner?()
    }
    
}
