///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) LICENSE file
/// 2) https://apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
/// Created by Alex Kozin
/// 2020 El Machine

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
