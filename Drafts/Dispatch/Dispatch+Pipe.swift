//  Copyright © 2020-2022 Alex Kozin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2022 Alex Kozin
//

import Foundation


//extension DispatchTime: Asking {
//
//    static func ask<T>(with: Any?, in pipe: Pipe, expect: Event<T>) {
//
//        let after = with as! DispatchTimeInterval
//
//
//        let timer = DispatchSource.makeTimerSource()
//        timer.schedule(deadline: .now() + after, repeating: after)
//        timer.setEventHandler {
//            expecting.handle(timer)
//        }
//        timer.activate()
//
//        switch expecting.condition {
//
//            case .every, .while:
//
//                let timer = DispatchSource.makeTimerSource()
//                timer.schedule(deadline: .now() + after, repeating: after)
//                timer.setEventHandler {
////                    expecting.handle(timer)
//                }
//                timer.activate()
//
//            case .once:
//                
//
////                OperationQueue.current?.underlyingQueue
////                DispatchQueue.asyncAfter(<#T##self: DispatchQueue##DispatchQueue#>)
//        }
//    }
//
//
//}

//public extension DispatchQueue {
//
//    enum Work {
//        case async(()->() )
//        case sync(()->() )
//    }
//
//    static func |(piped: DispatchQueue, work: ()->() ) {
//        piped.sync(execute: work)
//    }
//
//}

public func | (piped: DispatchQoS.QoSClass, work: @escaping ()->() ) {
    DispatchQueue.global(qos: piped).async(execute: work)
}
//
//public func | (p: DispatchQoS.QoSClass, work: DispatchQueue.Work) {
//    let q = DispatchQueue.global(qos: p)
//    switch work {
//        case .async(let work):
//            q.async(execute: work)
//        case .sync(let work):
//            q.sync(execute: work)
//    }
//}

public func | (p: DispatchTime, work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: p, execute: work)
}

