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

/// Object that supports Wand
public
protocol Wanded {

    var wand:       Wand    {get}
    var isWanded:   Wand?   {get}

}

extension Wanded {

    public
    var wand:       Wand    {
        isWanded ?? Wand(for: self)
    }

    public
    var isWanded:   Wand?   {
        Wand[self]
    }

}

/// Any?: Wanded
extension Optional: Wanded {

    public
    var wand: Wand {
        isWanded ?? .to(self)
    }

    public
    var isWanded: Wand? {
        Wand[self]
    }

}
