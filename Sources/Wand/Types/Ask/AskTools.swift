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

/// Optional
public
extension Ask {

    class Optional: Ask {

        private
        weak var _weak_wand: Wand?

        override func set(wand: Wand) {
            _weak_wand = wand
        }

    }

    func optional() -> Ask {
        type(of: self).Optional(key: key, handler: handler)
    }

}

/// Ask for completion
///
/// wand | .all {
///
/// }
public
extension Ask {

    class All: Optional {

        required
        init(key: String? = nil,
             handler: @escaping (T) -> (Bool)) {
            super.init(key: "All", handler: handler)
        }
    }

    static func all(handler: @escaping ()->() ) -> Ask<Wand>.All {
        .All() { _ in
            handler()
            return false
        }
    }

}

@discardableResult
public func | (wand: Wand, all: Ask<Wand>.All ) -> Wand {
    _ = wand.answer(the: all)
    return wand
}

/// While counting
public
extension Ask {

    static func `while`(key: String? = nil,
                        handler: @escaping (T, Int)->(Bool) ) -> Ask {
        var i = 0
        return Ask(key: key) {
            defer {
                i += 1
            }

            return handler($0, i)
        }

    }

}
