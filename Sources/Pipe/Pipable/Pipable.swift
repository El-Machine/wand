//
//  Pipable.swift
//  Sample
//
//  Created by Alex Kozin on 09.12.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

postfix operator |
prefix operator |

protocol Pipable {

    func pipe() -> Pipe
    func pipe() -> Pipe?
    
    var debugPipe: Pipe? {get}

}

extension Pipable {
    
    var debugPipe: Pipe? {
        pipe()
    }
    
    func pipe() -> Pipe {
        pipe() ?? {
            let pipe = Pipe()
            pipe.put(self)

            return pipe
        }()
    }
    
    func pipe() -> Pipe? {
        Pipe.pipes[self|]
    }
    
}

//Close
prefix func | (piped: Pipable) {
    piped.pipe()?.close()
}

//Weld two pipes
func |<R: Pipable>(left: Pipable?, right: R) -> R {
    left?.pipe()?.weld(with: right) ?? right
}

//From pipe
postfix func |<T> (pipable: Pipable?) -> T? {
    (pipable as? T) ?? pipable?.pipe()?.get()
}

//Force unwrap
//postfix func |!<T> (pipable: Pipable) -> T {
//    (pipable as? T) ?? pipable.pipe().get()!
//}

//String from Any
postfix func | (object: Any) -> String {
    if let arg = object as? CVarArg {
        return String(format: "%p", arg)
    } else {
        return String(describing: object)
    }
}

//Error
@discardableResult
func |<T: Pipable> (pipable: T, handler: @escaping (Error)->()) -> T {
    pipable | .every(exclusive: true, handler: handler)
}
