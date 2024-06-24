/////
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

extension Ask {

    /// Ask?
    /// .Option Ask won't retain Wand
    public
    class Option: Ask {

        @inline(__always)
        override
        public
        func set(wand: Wand) {
        }

        @inline(__always)
        override
        public
        func optional() -> Self {
            self
        }

    }

    @inline(__always)
    public
    func option<U>(for key: String? = nil, handler: ( (U) -> () )? = nil ) -> Ask<U>.Option {
        Ask<U>.Option.init(once: self.once, for: key, handler: handler)
    }

    @inline(__always)
    public
    func optionWhile<U>(for key: String? = nil, handler: @escaping (U) -> (Bool) ) -> Ask<U>.Option {

        Ask<U>.Option.init(once: false, for: key, handler: handler)
    }

}
