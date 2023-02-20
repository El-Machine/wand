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
import CloudKit

/**
 Add error handler
 - Parameters:
 - handler: Will be invoked only after error
 */
@discardableResult
public func | (piped: Pipable, handler: @escaping (Error)->() ) -> Pipe {
    let pipe = piped.pipe
    _ = pipe.ask(for: .every(Error.self, handler: handler).inner())

    return pipe
}

/**
 Add success and error handler
 - Parameters:
 - handler: Will be invoked after success and error
 */
//@discardableResult
//public func | (piped: Pipable, handler: @escaping (Error?)->() ) -> Pipe {
//    //TODO: Rewrite "Error" expectations
//    let pipe = piped.pipe
//
//    _ = pipe.expect(.every(handler).inner())
//
//    //    pipe.expectations["Error"] = [
//    //        Expect.every(handler)
//    //    ]
//
//    return pipe
//}

extension Pipe {

    struct Error: Swift.Error {

        let reason: String

        init(_ reason: String, function: String = #function) {
            self.reason = function + reason
        }

        static func vision(_ reason: String) -> Error {
            Self(reason)
        }

    }

}
