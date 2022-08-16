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

    var with: Any? {get}
    var isInner: Bool {get}

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

    let with: Any?
    let condition: Condition

    let handler: Handler
    var cleaner: ( ()->() )?

    private(set) var isInner = false
    func inner() -> Expect<E> {
        isInner = true
        return self
    }

    internal required init(with: Any? = nil,
                           condition: Condition,
                           handler: @escaping Handler) {
        self.with = with
        self.condition = condition
        self.handler = handler
    }

    //Event
    static func every(handler: ((E)->() )? = nil) -> Self {
        Self(condition: .every) {
            handler?($0)
            return true
        }
    }
    
    static func one(handler: ((E)->() )? = nil) -> Self {
        Self(condition: .one) {
            handler?($0)
            return false
        }
    }

    static func `while`(_ key: String? = nil,
                        handler: @escaping (E)->(Bool) ) -> Self {
        Self(condition: .while, handler: handler)
    }

    //Condition
    static func all(handler: @escaping (Any)->() ) -> Expect<Any> {
        Expect<Any>(condition: .all) {
            handler($0)
            return false
        }
    }

    static func any(handler: @escaping (Any)->() ) -> Expect<Any> {
        Expect<Any>(condition: .any) {
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
    static func every(_ with: E.With,
                      handler: ((E)->() )? = nil) -> Self {
        Self(with: with, condition: .every) {
            handler?($0)
            return true
        }
    }

    static func one(_ with: E.With,
                    handler: ((E)->() )? = nil) -> Self {
        Self(with: with, condition: .one) {
            handler?($0)
            return false
        }
    }

    static func `while`(_ with: E.With,
                        handler: @escaping (E)->(Bool)) -> Self {
        Self(with: with, condition: .while, handler: handler)
    }

}
