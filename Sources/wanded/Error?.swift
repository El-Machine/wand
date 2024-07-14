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

/// Handle Error and Success
///
/// wand | { (error: Error?) in
///
/// }
///
@discardableResult
@inline(__always)
public
func | (wand: Wand, handler: @escaping (Error?)->() ) -> Wand {

    //Handle Succeed completion
    let all = Ask<Wand>.all { _ in
        handler(nil)
    }

    //Handle Error completion

    let everyError = { (e: Error) in
        all.cancel()
        handler(e)
    }

    return wand | all | Ask.Option(once: false, handler: everyError)
}

/// Handle Error and Success
///
/// wand | .one { (error: Error?) in
///
/// }
///
@discardableResult
@inline(__always)
public
func | (wand: Wand, ask: Ask<Error?>) -> Wand {
    
    //Handle Succeed completion
    let all = Ask<Wand>.all { _ in
        _ = ask.handler(nil)
    }

    //Handle Error completion
    return wand | all | ask.option {
        all.cancel()
        _ = ask.handler($0)
    }

}
