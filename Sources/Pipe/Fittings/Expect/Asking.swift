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

/**
 Prepares environment for requesting instance of E
 - Without anything
 - With incoming objects
 */
protocol Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>)
    static func key(from: Any?) -> String?

}

extension Asking {

    /**
     Default key is object type
     Provide custom key to avoid collisions

     - SeeAlso:
     [Notification.Name]()
     */
    static func key(from: Any?) -> String? {
        nil
    }

}



protocol AskingWith: Asking {

    associatedtype With: AskingFrom, RawRepresentable where With.RawValue == String

}

extension AskingWith  {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        (with as! With).asking.ask(with: with, in: pipe, expect: expect)
    }

}

protocol AskingFrom {

    var asking: Asking.Type {get}

}

//Asking Aray asks Element
extension Array: Asking where Element: Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        Element.ask(with: with, in: pipe, expect: expect)
    }

}

struct UnexpectedAsking: Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        print("🔥 \(E.self) not produced\n Unexpected behaviour on \(pipe)")
    }

}

protocol WaitAsking: Asking {

}

extension WaitAsking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        print("🔎 Waiting for \(E.self)")
    }

}

struct Waiter: WaitAsking {

}
