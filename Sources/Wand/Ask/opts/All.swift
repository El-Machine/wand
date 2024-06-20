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

/// Ask for the completion
///
/// wand | .all {
///
/// }
/// 
public
extension Ask {

    class All: Option {

        /// Ask.all
        @inline(__always)
        public
        required
        init(for key: String? = nil, handler: @escaping (T) -> (Bool)) {
            super.init(for: "All", handler: handler)
        }
        
    }

    /// .all
    @inline(__always)
    static
    func all(handler: @escaping ()->() ) -> Ask<Wand> {
        .All() { _ in
            handler()
            return false
        }
    }

}

/// Add completion to wand
@discardableResult
@inline(__always)
public
func | (wand: Wand, all: Ask<Wand>) -> Wand {
    _ = wand.answer(the: all)
    return wand
}
