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

/// Create object with default settings
/// Use options to customize.
public protocol Constructable: Pipable {

    static func construct(in pipe: Pipe) -> Self

}

/// Construct on type
public postfix func |<T: Constructable>(type: T.Type) -> T {
    T.construct(in: Pipe())
}

/// Construct
public postfix func |<T: Constructable>(pipe: Pipe?) -> T {
    if let pipe {
        return pipe.get() ?? T.construct(in: pipe)
    }

    return T.construct(in: Pipe())
}

/// Construct with settings
public postfix func |<P, T: Constructable>(settings: P) -> T {
    let pipe = Pipe.attach(to: settings)
    return pipe.get() ?? T.construct(in: pipe)
}

public extension Pipe {

    /// Create Constructable if need
    /// - Parameter key: Stroring key
    /// - Returns: T
    func get<T: Constructable>(for key: String? = nil) -> T {
        let get: T? = get(for: key)
        return get ?? self|
    }
    
}
