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

    static func start<P, E: Expectable>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe)

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
public func |<E: Expectable, P> (piped: P, handler: @escaping (E)->() ) -> Pipe {
    piped | .every(handler)
}

///  Expect E from nil
///
/// - Parameters:
///   - pipe: Pipe that provides context
///   - handler: Block to use E
///
///   | { E in
///
///   }
@discardableResult
public func |<E: Expectable> (pipe: Pipe?, handler: @escaping (E)->() ) -> Pipe {
    (pipe ?? Pipe()) as Any | .every(handler)
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
public func |<E: Expectable, P> (piped: P, expectation: Expect<E>) -> Pipe {
    let pipe = Pipe.attach(to: piped)
    E.start(expectating: expectation, with: piped, on: pipe)

    return pipe
}


///  Add expectations to chain
///  Start both
///
///  CLLocation.one | CMPedometerEvent.one
///
@discardableResult
public func |<P: Expectable, E: Expectable> (piped: Expect<P>, to: Expect<E>) -> Pipe {
    let pipe = Pipe()
    P.start(expectating: piped, with: pipe, on: pipe)
    E.start(expectating: to, with: piped, on: pipe)

    return pipe
}

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
