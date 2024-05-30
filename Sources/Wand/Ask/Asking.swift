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

/// Ask from Context
/// func | (wand: Wand, asks: Ask<Self>)
public
protocol Asking {

    @inline(__always)
    static func wand<T>(_ wand: Wand, asks: Ask<T>)

}

/// Ask
///
/// any | { T in
///
/// }
/// 
@inline(__always)
@discardableResult
public
func |<C, T: Asking> (context: C?, handler: @escaping (T)->() ) -> Wand {
    .to(context) | Ask.every(handler: handler)
}

/// Ask
/// - `every`
/// - `one`
/// - `while`
///
/// any | .one { T in
///
/// }
///
@inline(__always)
@discardableResult
public
func |<C, T: Asking> (context: C?, ask: Ask<T>) -> Wand {
    .to(context) | ask
}

/// Ask
///
/// wand | .every { T in
///
/// }
///
@inline(__always)
@discardableResult
public
func |<T: Asking> (wand: Wand, ask: Ask<T>) -> Wand {
    T.wand(wand, asks: ask)
    return wand
}

/// Ask without handler
///
/// Foo.one | Bar.every | { (error: Error) in
///
/// }
///
extension Asking {

    @inline(__always)
    public
    static
    var every: Ask<Self> {
        .every()
    }

    @inline(__always)
    public
    static
    var one: Ask<Self> {
        .one()
    }
    
}
