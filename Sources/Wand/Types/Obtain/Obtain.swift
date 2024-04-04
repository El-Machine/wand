/// Copyright © 2020-2024 El Machine 🤖
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

import Foundation

/// Get Object from Wand or create in Context
public
protocol Obtain {

    static func obtain(by wand: Wand?) -> Self

}

/// Obtain
///
/// let object = T|
///
public postfix func |<T: Obtain>(type: T.Type) -> T {
    T.obtain(by: nil)
}

/// Obtain
///
/// let object: T = wand|
///
public postfix func |<T: Obtain>(wand: Wand?) -> T {
    wand?.get() ?? {

        let object = T.obtain(by: wand)
        return wand?.add(object) ?? object


    }()
}

public extension Wand {

    func obtain <T: Obtain> (for key: String? = nil) -> T {
        get(for: key, or: T.obtain(by: self))
    }
    
}

/// Obtain
///
/// let object: T = context|
///
public
postfix func |<C, T: Obtain>(context: C) -> T {
    Wand.attach(to: context).obtain()
}

/// Obtain unwrap
///
/// let option: T? = nil
///
/// let object = optional|
///
public
postfix func |<T: Obtain> (object: T?) -> T {
    object ?? T.self|
}
