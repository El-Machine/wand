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

protocol AskFor {

    var isInner: Bool {get}

}

public
class Ask<T>: AskFor {

    public
    enum Condition {

        case every, one, `while`

    }

    let condition: Condition

    var key: String?

    public
    var handler: (T)->(Bool)

    public
    var cleaner: ( ()->() )?

    //Inner is not asked by user
    public private(set)
    var isInner: Bool = false

    public
    func inner() -> Self {
        isInner = true
        return self
    }

    internal required
    init(_ condition: Condition,
         key: String? = nil,
         handler: @escaping (T) -> Bool) {

        self.condition = condition
        self.key = key
        self.handler = handler
    }

    public
    static func every(_ type: T.Type? = nil,
                      key: String? = nil,
                      handler: ( (T)->() )? = nil ) -> Self {
        Self(.every, key: key) {
            handler?($0)

            //Retry?
            return true
        }
    }

    public
    static func one(_ type: T.Type? = nil,
                    handler: ( (T)->() )? = nil ) -> Self {
        Self(.one) {
            handler?($0)

            //Retry?
            return false
        }
    }

    public
    static func `while`(_ type: T.Type? = nil,
                        handler: @escaping (T)->(Bool) ) -> Self {
        //Decide to retry in handler
        Self(.while, handler: handler)
    }

}

extension Ask {

    //While counting
    public
    static func `while`(_ handler: @escaping (T, Int)->(Bool) ) -> Self {
        var i = 0
        return Self(.while) {
            defer {
                i += 1
            }

            return handler($0, i)
        }
    }

}
