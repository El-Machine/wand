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
 Expect is expectation of object E in pipe
 Calls 'handler' when E will be putted to Pipe
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

    let condition: Condition
    let key: String?
    let inner: Bool

    let handler: Handler
    var cleaner: ( ()->() )?

    internal required init(condition: Condition,
                           key: String? = nil,
                           inner: Bool = false,
                           handler: @escaping Handler) {
        self.condition = condition

        self.key = key
        self.inner = inner
        self.handler = handler
    }

    //Event
    static func every(key: String? = nil,
                      inner: Bool = false,
                      handler: ((E)->())? = nil) -> Self {
        Self(condition: .every, key: key, inner: inner) {
            handler?($0)
            return true
        }
    }
    
    static func one(key: String? = nil,
                     inner: Bool = false,
                     handler: ((E)->())? = nil) -> Self {
        Self(condition: .one, key: key, inner: inner) {
            handler?($0)
            return false
        }
    }

    static func `while`(key: String? = nil,
                        inner: Bool = false,
                        handler: @escaping (E)->(Bool) ) -> Self {
        Self(condition: .while, key: key, inner: inner) {
            return handler($0)
        }
    }

    //Condition
    static func all(handler: @escaping (Any)->()) -> Expect<Any> {
        Expect<Any>(condition: .all, key: "All", inner: true) {
            handler($0)
            return false
        }
    }

    static func any(key: String? = nil,
                    handler: @escaping (Any)->()) -> Expect<Any> {
        Expect<Any>(condition: .any, key: key, inner: true) {
            handler($0)
            return false
        }
    }

    deinit {
        cleaner?()
    }
    
}
