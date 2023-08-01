//
//  ARAnchor_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 06.07.2023.
//  Copyright © 2023 El Machine. All rights reserved.
//

import ARKit
import Foundation

extension Ask where T == [ARAnchor] {

    class DidAdd: Ask {
    }

    class DidUpdate: Ask {
    }

    static func didAdd(handler: @escaping ([ARAnchor])->() ) -> DidAdd {
        DidAdd.every(handler)
    }

    static func didUpdate(handler: @escaping ([ARAnchor])->() ) -> DidUpdate {
        DidUpdate.every(handler)
    }

}

@discardableResult
prefix func | (ask: Ask<[ARAnchor]>.DidAdd) -> Pipe {
    Pipe() | ask
}

@discardableResult
prefix func | (ask: Ask<[ARAnchor]>.DidUpdate) -> Pipe {
    Pipe() | ask
}

@discardableResult
func |<T> (scope: T, ask: Ask<[ARAnchor]>.DidAdd) -> Pipe {

    let pipe = Pipe.attach(to: scope)

    guard pipe.start(expecting: ask, key: type(of: ask)|) else {
        return pipe
    }

    let session = (scope as? ARSession) ?? pipe.get()

    ask.cleaner = {
        session.pause()
    }

    return pipe
}

@discardableResult
func |<T> (scope: T, ask: Ask<[ARAnchor]>.DidUpdate) -> Pipe {
    let pipe = Pipe.attach(to: scope)

    ask.key = type(of: ask)|

    guard pipe.ask(for: ask) else {
        return pipe
    }

    let session = (scope as? ARSession) ?? pipe.get()

    ask.cleaner = {
        session.pause()
    }

    return pipe
}

@available(*, unavailable, message: "Use label \n .didAdd \n .didUpdate")
@discardableResult
prefix func | (handler: @escaping ([ARAnchor])->() ) -> Pipe {
    fatalError()
}

