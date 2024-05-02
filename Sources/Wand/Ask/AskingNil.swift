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

import Foundation

/// Ask from Nil
public protocol AskingNil: Asking {

}

/// Ask
///
/// |{ T in
///
/// }
///
@discardableResult
@inline(__always)
public prefix func |<T: Asking> (handler: @escaping (T)->() ) -> Wand {
    nil | Ask.every(handler: handler)
}

/// Ask
/// - `every`
/// - `one`
/// - `while`
///
/// |.one { T in
///
/// }
///
@discardableResult
@inline(__always)
public prefix func |<T: Asking> (ask: Ask<T>) -> Wand {
    nil | ask
}

/// Make the chain
///
/// T.one | E.one | { (error: Error) in
///
/// }
///
@discardableResult
@inline(__always)
public func |<T: AskingNil, E: Asking>(l: Ask<T>, r: Ask<E>) -> Wand {
    let wand = Wand()
    T.wand(wand, asks: l)
    E.wand(wand, asks: r)

    return wand
}
