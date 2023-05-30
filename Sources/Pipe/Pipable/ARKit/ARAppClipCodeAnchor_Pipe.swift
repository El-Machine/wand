//
//  ARAppClipCodeAnchor_Pipe.swift
//  Pipe
//
//  Created by Alex Kozin on 20.10.2022.
//

import ARKit.ARAnchor

@available(iOS 13.0, *)
extension ARAnchor: Asking {

    public
    static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {

        guard pipe.ask(for: ask) else {
            return
        }

        let session: ARSession = pipe.get()

        ask.cleaner = {
            session.pause()
        }

    }


}

public
extension Ask {

    class Add: Ask {
    }

    class Update: Ask {
    }

    class Remove: Ask {
    }

}

@available(iOS 13.0, *)
public extension Ask where T == Array<ARAnchor> {

    static func add(_ handler: ( (T)->() )? = nil) -> Add {
        .every(key: #function, handler: handler)
    }

    static func update(_ handler: ( (T)->() )? = nil) -> Update {
        .every(key: #function, handler: handler)
    }

    static func remove(_ handler: ( (T)->() )? = nil) -> Remove {
        .every(key: #function, handler: handler)
    }

}

import ARKit.ARAppClipCodeAnchor

@available(iOS 14.3, *)
@discardableResult
public
prefix func | (ask: Ask<[ARAppClipCodeAnchor]>) -> Pipe {

    let configuration = ARWorldTrackingConfiguration()
    configuration.automaticImageScaleEstimationEnabled = true
    configuration.appClipCodeTrackingEnabled = true

    //Ask for [ARAnchor] with AR config
    return (configuration as ARConfiguration) | ask
}
