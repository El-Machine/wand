///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) .LICENSE
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

import Foundation

/// Ask the question
open
class Ask<T> {

    public
    var handler: (T)->(Bool)

    public
    var next: Ask?

    public
    var once: Bool {
        false
    }

    ///@synthesize `key`
    internal
    var _key: String?

    @inline(__always)
    public
    var key: String {
        get {
            _key ?? T.self|
        }
        set {
            _key = newValue
        }
    }

    ///@synthesize `wand`
    private
    var wand: Wand?

    @inline(__always)
    open
    func set(wand: Wand) {
        self.wand = wand
    }

    ///.init
    @inline(__always)
    public
    required
    init(for key: String? = nil,
         handler: @escaping (T) -> (Bool) ) {

        self._key = key
        self.handler = handler
    }

    //TODO: Move to `Option`
    //`instance methods declared in extensions cannot be overridden`
    @inline(__always)
    public
    func optional() -> Option {
        Option(for: key, handler: handler)
    }

}

/// Request object
/// - `every`
/// - `one`
/// - `while`
public
extension Ask {

    /// Ask
    ///
    /// |.every { T in
    ///
    /// }
    ///
    @inline(__always)
    static
    func every(_ key: String? = nil, handler: ( (T)->() )? = nil ) -> Every {
        Every(for: key) {
            handler?($0)
            return true
        }
    }

    /// Ask
    ///
    /// |.one { T in
    ///
    /// }
    ///
    @inline(__always)
    static 
    func one(_ key: String? = nil, handler: ( (T)->() )? = nil ) -> One {
        One(for: key) {
            handler?($0)
            return false
        }
    }

    /// Ask
    ///
    /// |.while { T in
    ///     true
    /// }
    ///
    @inline(__always)
    static 
    func `while`(_ key: String? = nil, handler: @escaping (T)->(Bool) ) -> Self {
        Self(for: key, handler: handler)
    }

}

/// Handle answer
extension Ask {

    open
    class One: Ask {

        override
        public
        var once: Bool {
            true
        }

        @inline(__always)
        public
        convenience
        init(for key: String? = nil,
             handler: @escaping (T) -> () ) {

            self.init(for: key) {
                handler($0)
                return false
            }
        }

    }

    open
    class Every: Ask {

        @inline(__always)
        public
        convenience
        init(for key: String? = nil,
             handler: @escaping (T) -> () ) {

            self.init(for: key) {
                handler($0)
                return true
            }
        }

    }

    @discardableResult
    @inline(__always)
    public
    func head(_ object: T) -> Ask? {
        let head = next
        self.next = nil

        return head?.handle(object)
    }

    @inlinable
    internal
    func handle(_ object: T) -> Ask? {
        
        //Store ask while true
        if handler(object) 
        {
            let tail = next?.handle(object) ?? self
            tail.next = self
            return tail
        } 
        else
        {
            return next?.handle(object)
        }

    }

}

/// Nulify handler
extension Ask {

    @inline(__always)
    public
    func cancel() {
        handler = { [weak self] _ in
            self?.once == false
        }
    }

}
