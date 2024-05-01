/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
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

/// The question
open
class Ask<T> {

    var handler: (T)->(Bool)

    var next: Ask?

    public
    let once: Bool

    private
    var _key: String?

    public
    var key: String {
        get {
            _key ?? T.self|
        }
        set {
            _key = newValue
        }
    }

    private
    var wand: Wand?
    func set(wand: Wand) {
        self.wand = wand
    }

    public
    required
    init(key: String? = nil,
         once: Bool = false,
         handler: @escaping (T) -> (Bool)) {

        self._key = key
        self.once = once
        self.handler = handler
    }

    static func once (_ once: Bool,
                      key: String? = nil,
                      handler: ( (T) -> () )? = nil) -> Ask {

        self.init(key: key) {
            handler?($0)
            return !once
        }

    }

}

/// Request object
/// - `every`
/// - `one`
/// - `while`
public
extension Ask {

    @inline(__always)
    static func every(_ key: String? = nil, handler: ( (T)->() )? = nil ) -> Ask {
        Ask(key: key) {
            handler?($0)
            return true
        }
    }

    @inline(__always)
    static func one(_ key: String? = nil, handler: ( (T)->() )? = nil ) -> Ask {
        Ask(key: key, once: true) {
            handler?($0)
            return false
        }
    }

    @inline(__always)
    static func `while`(_ key: String? = nil, handler: @escaping (T)->(Bool) ) -> Ask {
        Ask(key: key, handler: handler)
    }

}

/// Handle answer
extension Ask {

    @discardableResult
    internal
    func head(_ object: T) -> Ask? {
        let head = next
        self.next = nil

        return head?.handle(object)
    }

    internal
    func handle(_ object: T) -> Ask? {
        //Save while true
        if handler(object) {
            let tail = next == nil ? self : next?.handle(object) ?? self
            tail.next = self

            return tail
        } else {
            return next?.handle(object)
        }
    }
}
