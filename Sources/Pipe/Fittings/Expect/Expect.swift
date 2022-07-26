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

    var inner: Bool {get}

}

/**
 Expecting instance of E.
 Will call `handler` when E will be putted to pipe.
 - `every`  time
 - `one`    only
 - `while`  returns true

 */
final class Expect<E>: Expecting {
    
    enum Condition: String {
        case every, one, `while`,
             all, any
    }

    typealias Handler = (E)->(Bool)

    let `for`: Any?

    let key: String

    let condition: Condition

    let inner: Bool

    let handler: Handler
    var cleaner: ( ()->() )?

    internal required init(for: Any? = nil,
                           key: String? = nil,
                           condition: Condition,
                           inner: Bool = false,
                           handler: @escaping Handler) {

        self.`for` = `for`
        self.key = key ?? E.self|

        self.condition = condition

        self.inner = inner

        self.handler = handler
    }

    //Event
    static func every(_ key: String? = nil,
                      inner: Bool = false,
                      handler: ((E)->())? = nil) -> Self {
        Self(key: key, condition: .every, inner: inner) {
            handler?($0)
            return true
        }
    }
    
    static func one(_ key: String? = nil,
                     inner: Bool = false,
                     handler: ((E)->())? = nil) -> Self {
        Self(key: key, condition: .one, inner: inner) {
            handler?($0)
            return false
        }
    }

    static func `while`(_ key: String? = nil,
                        inner: Bool = false,
                        handler: @escaping (E)->(Bool) ) -> Self {
        Self(key: key, condition: .while, inner: inner) {
            return handler($0)
        }
    }

    //Condition
    static func all(handler: @escaping (Any)->()) -> Expect<Any> {
        Expect<Any>(key: "All", condition: .all, inner: true) {
            handler($0)
            return false
        }
    }

    static func any(handler: @escaping (Any)->()) -> Expect<Any> {
        Expect<Any>(key: nil, condition: .any, inner: true) {
            handler($0)
            return false
        }
    }

    deinit {
        cleaner?()
    }
    
}

extension Expect where E: AskingWith {

    //Init with
    static func every(_ for: E.With,
                      inner: Bool = false,
                      handler: ((E)->())? = nil) -> Self {
        Self(for: `for`, key: `for`.rawValue, condition: .every, inner: inner) {
            handler?($0)
            return true
        }
    }

    static func one(_ for: E.With,
                    inner: Bool = false,
                    handler: ((E)->())? = nil) -> Self {
        Self(for: `for`, key: `for`.rawValue, condition: .one, inner: inner) {
            handler?($0)
            return true
        }
    }

    static func `while`(_ for: E.With,
                        inner: Bool = false,
                        handler: ((E)->())? = nil) -> Self {
        Self(for: `for`, key: `for`.rawValue, condition: .while, inner: inner) {
            handler?($0)
            return true
        }
    }

}
