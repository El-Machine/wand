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

public class AskFor {

    public enum Condition {

        case every, one, `while`,
             all, any

    }

    var isInner: Bool = false

    init() {
    }

}

public class Ask<T>: AskFor {

    let condition: Condition
    var handler: (T)->(Bool)

    public var cleaner: ( ()->() )?

    //Inner is not asked by user
    public func inner() -> Self {
        isInner = true
        return self
    }

    internal required init(_ condition: Condition,
                           handler: @escaping (T) -> Bool) {

        self.condition = condition
        self.handler = handler

        super.init()
    }

    public
    static func every(_ type: T.Type? = nil, handler: ( (T)->() )? = nil ) -> Self {
        Self(.every) {
            handler?($0)

            //Retry?
            return true
        }
    }

    public
    static func one(handler: ( (T)->() )? = nil ) -> Self {
        Self(.one) {
            handler?($0)

            //Retry?
            return false
        }
    }

    public
    static func `while`(handler: @escaping (T)->(Bool) ) -> Self {
        //Decide to retry in handler
        Self(.while, handler: handler)
    }

}
