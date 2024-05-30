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

/// Get Object from Wand 
/// or create in Context
public
protocol Obtain: Wanded {

    @inline(__always)
    static 
    func obtain(by wand: Wand?) -> Self

}

/// Obtain
///
/// let object = T|
///
@inline(__always)
postfix
public
func |<T: Obtain>(type: T.Type) -> T {
    T.obtain(by: nil)
}

/// Obtain
///
/// let object: T = wand|
///
@inline(__always)
postfix
public
func |<T: Obtain>(wand: Wand?) -> T {
    wand?.get() ?? {

        let object = T.obtain(by: wand)
        return wand?.add(object) ?? object

    }()
}

/// Obtain
///
/// let object: T = wand.obtain()
///
public
extension Wand {

    @inline(__always)
    func obtain <T: Obtain> (for key: String? = nil) -> T {
        get(for: key, or: T.obtain(by: self))
    }
    
}

/// Obtain
///
/// let object: T = context|
///
@inline(__always)
postfix
public
func |<C, T: Obtain>(context: C) -> T {
    Wand.to(context).obtain()
}

/// Obtain unwrap
///
/// let option: T? = nil
/// let object = option|
///
@inline(__always)
postfix
public
func |<T: Obtain> (object: T?) -> T {
    object ?? T.self|
}
