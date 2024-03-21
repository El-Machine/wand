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

public
protocol AskFor {

    var isInner: Bool {get}

}

public
class Ask<T>: AskFor {

    var key: String?

    //Inner is not asked by user
    public private(set)
    var isInner: Bool = false

    func inner() -> Self {
        isInner = true
        return self
    }

    func handle(_ object: T) -> Bool {
        fatalError()
    }

    public
    class Every: Ask {

        let handler: ( (T)->() )?

        required 
        init(key: String? = nil,
             handler: ( (T)->() )? = nil) {

            self.handler = handler
            super.init()
            self.key = key

        }

        override func handle(_ object: T) -> Bool {
            handler?(object)
            return true
        }

    }

    public
    class One: Ask {

        let handler: ( (T)->() )?

        required
        init(key: String? = nil,
             handler: ( (T)->() )? = nil) {

            self.handler = handler
            super.init()
            self.key = key

        }

        override func handle(_ object: T) -> Bool {
            handler?(object)
            return true
        }

    }

    public
    class While: Ask {

        let handler: (T)->(Bool)

        required
        init(key: String? = nil,
             handler: @escaping (T) -> (Bool)) {

            self.handler = handler
            super.init()
            self.key = key

        }

        override func handle(_ object: T) -> Bool {
            handler(object)
        }

    }

}

extension Ask {

    public
    static func every(_ type: T.Type? = nil,
                      key: String? = nil,
                      handler: ( (T)->() )? = nil ) -> Ask.Every {
        .Every(key: key, handler: handler)
    }

    public
    static func one(_ type: T.Type? = nil,
                    key: String? = nil,
                    handler: ( (T)->() )? = nil ) -> Ask.One {
        .One(key: key, handler: handler)
    }

    public
    static func `while`(key: String? = nil,
                        handler: @escaping (T)->(Bool) ) -> Ask.While {
        .While(key: key, handler: handler)
    }

}

//Sugar
extension Ask {

    //While counting
    public
    static func `while`(key: String? = nil,
                        handler: @escaping (T, Int)->(Bool) ) -> Ask.While {
        var i = 0
        return .While(key: key) {
            defer {
                i += 1
            }

            return handler($0, i)
        }

    }

}
