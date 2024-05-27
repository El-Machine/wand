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

/// Notify about any object
///
/// wand | .any { any in
///
/// }
/// 
public
extension Ask {
    
    /// .any
    @inline(__always)
    static
    func any(handler: @escaping (Any)->() ) -> Ask<Any> {
        .Optional() {
            handler($0)
            return true
        }
    }

}

/// Add any object handler
@inline(__always)
@discardableResult
public
func | (wand: Wand, any: Ask<Any>) -> Wand {
    _ = wand.answer(the: any)
    return wand
}
