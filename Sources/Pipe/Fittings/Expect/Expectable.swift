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

/**
 Start expecting instance of E
 Every from Noting

 |{ E in

 }
 */
@discardableResult
prefix func |<E> (handler: @escaping (E)->()) -> Pipe {
    |.every(handler: handler)
}

/**
 Expect E with condition:
 - every
 - once
 - while

 |.once { E in

 }
 */
@discardableResult
prefix func |<E> (expect: Expect<E>) -> Pipe {
    Pipe().add(expect)
}

/**
 Expect E from piped object

 P? | { E in

 }
 */
@discardableResult
func |<E, P> (piped: P?, handler: @escaping (E)->()) -> Pipe {
    piped | .every(handler: handler)
}

/**
 Expect E from piped object
 With condition:
 - `every`  piped object
 - `one`    only
 - `while`  returns true

 P? | .once { E in

 }
 */
@discardableResult
func |<E, P> (piped: P?, expect: Expect<E>) -> Pipe {
    piped.pipe.add(expect, with: piped)
}

/**
 Add expectation to chain started from Expect
 E.every | .once { T in

 }
 */
@discardableResult
func |<E, T> (piped: Expect<E>, expect: Expect<T>) -> Pipe {
    Pipe().add(piped, with: piped).add(expect, with: piped)
}

//Expect
extension Pipe {

    var expectations: [String: [Any]] {
        get {
            piped["expect"] as? [String : [Any]] ?? [:]
        }
        set {
            piped["expect"] = newValue
        }
    }

    @discardableResult
    func add<E>(_ expectation: Expect<E>,
                with: Any? = nil,
                asking: Asking.Type? = nil) -> Pipe {
        //Asking T from
        let asking: Asking.Type = asking
                                ?? E.self as? Asking.Type
                                ?? Waiter.self

        //With key
        let key =  expectation.key

        let stored = expectations[key]
        let isFirst = stored == nil

        //Store expectation
        expectations[key] = (stored ?? []) + [expectation]

        //Ask for the first time
        if isFirst {
            asking.ask(with: with ?? expectation.for, in: self, expect: expectation)
        }

        return self
    }

}

protocol Expectable {

}

extension Expectable {

    static var every: Expect<Self> {
        .every()
    }

    static var one: Expect<Self> {
        .one()
    }

    //With handler
    static func every(_ handler: @escaping (Self)->() ) -> Expect<Self> {
        .every(handler: handler)
    }

    static func once(_ handler: @escaping (Self)->() ) -> Expect<Self> {
        .one(handler: handler)
    }

    static func `while`(_ handler: @escaping (Self)->(Bool) ) -> Expect<Self> {
        .while(handler: handler)
    }

}
