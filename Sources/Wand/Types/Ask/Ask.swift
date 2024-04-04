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

///The question

public
protocol AskAny {

    func clean()

}

public
class Ask<T> {

    var key: String?
    let handler: (T?)->(Bool)

    var next: Ask<T>?

    private
    var _strong_wand: Wand?

    func set(wand: Wand) {
        _strong_wand = wand
    }

    required
    init(key: String? = nil,
         handler: @escaping (T?) -> (Bool)) {

        self.key = key
        self.handler = handler
    }

    internal
    func handle(_ object: T?) -> Ask<T>? {
        //Save while true
        if handler(object) {

            next = next?.handle(object)
            return self

        } else {

            return next?.handle(object)

        }
    }
}

/// Clean
extension Ask: AskAny {

    internal
    func addCleaner(block: ( () -> () )? = nil) {
        let cleaner = Ask() { _ in
            block?()
            return false
        }

        next = cleaner
        cleaner.next = self
    }

    public
    func clean() {
        _ = next!.handler(nil)
        Wand.log("|🧼 \(self)")
    }

}

/// Request object
/// - `every`
/// - `one`
/// - `while`
public
extension Ask {

    class Every: Ask {
    }

    class One: Ask {
    }

    static func every(_ type: T.Type? = nil,
                      key: String? = nil,
                      handler: ( (T)->() )? = nil ) -> Ask.Every {
        .Every(key: key) {
            handler?($0!)
            return true
        }
    }

    static func one(_ type: T.Type? = nil,
                    key: String? = nil,
                    handler: ( (T)->() )? = nil ) -> Ask.One {
        .One(key: key) {
            handler?($0!)
            return false
        }
    }

    static func `while`(key: String? = nil,
                        handler: @escaping (T)->(Bool) ) -> Ask {
        Ask(key: key) {
            return handler($0!)
        }
    }

}

///Tools
public
extension Ask {

    class Optional: Ask {

        private 
        weak var _weak_wand: Wand?

        override func set(wand: Wand) {
            _weak_wand = wand
        }

    }

    func optional() -> Ask<T>.Optional {
        type(of: self).Optional(key: key, handler: handler)
    }

}

///Sugar
public
extension Ask {

    //While counting
    static func `while`(key: String? = nil,
                        handler: @escaping (T, Int)->(Bool) ) -> Ask {
        var i = 0
        return Ask(key: key) {
            defer {
                i += 1
            }

            return handler($0!, i)
        }

    }

}
