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

/// Pipe.ExpectableWithout
/// Requsts self from Nothing
///
/// #Usage
/// ```
///
/// ```
public protocol ExpectableWithout: Expectable {

}

///  Start expecting instance of E
///  Every from Noting
///
/// - Parameters:
///   - handler: Block that use E
///
///   |{ E in
///
///   }
@discardableResult
public prefix func |<E: ExpectableWithout> (handler: @escaping (E)->() ) -> Pipe {
    |.every(handler)
}


///  Expect E with condition:
///  - `every`
///  - `one`
///  - `while`
///
/// - Parameters:
///   - expectation: Expectation that provide requesting and receiving politics
///
///   |.one { E in
///
///   }
@discardableResult
public prefix func |<E: ExpectableWithout> (expectation: Expect<E>) -> Pipe {
    Pipe() | expectation
}

///  Expect E from nil
///  With condition:
///  - `every`  piped object
///  - `one`    only
///  - `while`  returns true
///
/// - Parameters:
///   - pipe: Pipe that provides context
///   - expectation: Expectation that provide requesting and receiving politics
///
///   |.one { E in
///
///   }
@discardableResult
public func |<E: Expectable> (pipe: Pipe?, expectation: Expect<E>) -> Pipe {
    (pipe ?? Pipe()) as Any | expectation
}
