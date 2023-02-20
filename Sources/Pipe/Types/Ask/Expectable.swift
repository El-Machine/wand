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

/// Pipe.Expectable
///
/// #Usage
/// ```
///   |{ (location: CLLocation) in
///
///   }
/// ```
public protocol Expectable {

    //E === Self
    static func expect<E: Expectable>(_ expectation: Expect<E>, from pipe: Pipe)

}

///  Expect E from piped object
///
/// - Parameters:
///   - piped: Object that provides context
///   - handler: Block to use E
///
///   | { E in
///
///   }
@discardableResult
public func |<S, E: Expectable> (scope: S, handler: @escaping (E)->() ) -> Pipe {
    scope | Expect.every(handler)
}

///  Expect E from piped object
///  With condition:
///  - `every`  piped object
///  - `one`    only
///  - `while`  returns true
///
/// - Parameters:
///   - piped: Object that provides context
///   - expectation: Expectation that provide requesting and receiving politics
///
///   |.one { E in;
///
///   }
@discardableResult
public func |<S, E: Expectable> (scope: S, expectation: Expect<E>) -> Pipe {
    let pipe = Pipe.attach(to: scope)
    E.expect(expectation, from: pipe)

    return pipe
}


///  Add expectations to chain
///  Start both
///
///  CLLocation.one | CMPedometerEvent.one
///
//@discardableResult
//public func |<P: Expectable, E: Expectable> (piped: Expect<P>, to: Expect<E>) -> Pipe {
//    let pipe = Pipe()
//    P.start(expectating: piped, with: pipe, on: pipe)
//    E.start(expectating: to, with: piped, on: pipe)
//
//    return pipe
//}

///  Expect from Self
///
///   T.one { E in
///
///   }
public extension Expectable {

    static var every: Expect<Self> {
        .every()
    }

    static var one: Expect<Self> {
        .one()
    }

    //With handler
    static func every(_ handler: @escaping (Self)->() ) -> Expect<Self> {
        .every(handler)
    }

    static func one(_ handler: @escaping (Self)->() ) -> Expect<Self> {
        .one(handler)
    }

    static func `while`(_ handler: @escaping (Self)->(Bool) ) -> Expect<Self> {
        .while(handler)
    }

}

public extension Expect where T: Expectable {

    static func every(_ with: String,
                      _ handler: ((T)->() )? = nil) -> Self {
        Self(with: with, condition: .every) {
            handler?($0)
            return true
        }
    }

    static func one(_ with: String,
                    _ handler: ((T)->() )? = nil) -> Self {
        Self(with: with, condition: .one) {
            handler?($0)
            return false
        }
    }

    static func `while`(_ with: String,
                        _ handler: @escaping (T)->(Bool)) -> Self {
        Self(with: with, condition: .while, handler: handler)
    }

}
