/////
///// Copyright © 2020-2024 El Machine 🤖
///// https://el-machine.com/
/////
///// Licensed under the Apache License, Version 2.0 (the "License");
///// you may not use this file except in compliance with the License.
///// You may obtain a copy of the License at
/////
///// 1) .LICENSE
///// 2) https://apache.org/licenses/LICENSE-2.0
/////
///// Unless required by applicable law or agreed to in writing, software
///// distributed under the License is distributed on an "AS IS" BASIS,
///// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///// See the License for the specific language governing permissions and
///// limitations under the License.
/////
///// Created by Alex Kozin
///// 2020 El Machine



extension Ask {

    /// Ask?
    /// .Option Ask won't retain Wand
    public
    class Option: Ask {

        private
        var _once: Bool = false

        override
        public
        var once: Bool {
            _once
        }

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

        @inline(__always)
        internal
        convenience
        init(for key: String? = nil, handler: @escaping (T) -> (), once: Bool) {

            self.init(for: key) {
                handler($0)

                return !once
            }

            self._once = once
        }

        @inline(__always)
        internal
        convenience
        init(for key: String? = nil, handler: @escaping (T) -> (Bool), once: Bool) {
            self.init(for: key, handler: handler)
            self._once = once
        }

        
        @inline(__always) 
        internal
        required
        init(for key: String? = nil, handler: @escaping (T) -> (Bool)) {
            super.init(for: key, handler: handler)
        }
        
    }

    @inline(__always)
    public
    func option<U>(for key: String? = nil,
                   handler: @escaping (U) -> () ) -> Ask<U>.Option {

        Ask<U>.Option.init(for: key, handler: handler, once: once)
    }

}
