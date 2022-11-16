//
//  ARAppClipCodeAnchor_Pipe.swift
//  Pipe
//
//  Created by Alex Kozin on 20.10.2022.
//

import ARKit.ARAnchor

extension ARAnchor: Pipable {

    public enum With: String {

        case add, update, remove

    }

}

extension Array<ARAnchor>: Expectable {

}

extension Array<ARAnchor>: ExpectableLabeled {

    public enum Label: String {

        case add, update, remove

    }

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {

//        let with = piped as! With
        let label = expectation.with as! Label

        guard pipe.start(expecting: expectation, key: label.rawValue) else {
            return
        }

        let session = (piped as? ARSession) ?? pipe.get()

        expectation.cleaner = {
            session?.pause()
        }

    }


}

public extension Expect where T == Array<ARAnchor> {

    static func add(handler: @escaping (T)->()) -> Self {
        Expect.every(.add, handler) as! Self
    }

    static func update(handler: @escaping (T)->()) -> Self {
        Expect.every(.update, handler) as! Self
    }

    static func remove(handler: @escaping (T)->()) -> Self {
        Expect.every(.remove, handler) as! Self
    }

}

import ARKit.ARAppClipCodeAnchor

//@available(iOS 14.3, *)
//extension ARAppClipCodeAnchor: Operatable, ExpectableWithout {
//
//    public typealias With = Array<ARAnchor>.With
//
//    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {
//
//        let with = expectation.with as! With
//        let key = E.self| + with.rawValue
//
//        guard pipe.start(expecting: expectation, key: key) else {
//            return
//        }
//
//        //Add flag: Waiting for some ARAnchor
//        let anchorKey = ARAnchor.self|
//        if pipe.expectations[anchorKey] == nil {
//            pipe.expectations[anchorKey] = []
//        }
//
//        with | [ARAnchor].every
//    }
//
//
//}



import ARKit.ARSession
import RealityKit

@available(iOS 13.0, *)
extension ARSession: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {
        //TODO: Create ARView if no?
        let arView = (piped as? ARView) ?? pipe.get()

        let session: Self = arView.session as! Self
        session.delegate = pipe.put(Delegate())

        if let configuration = (piped as? ARConfiguration) ?? pipe.get() {
            arView.automaticallyConfigureSession = false
            session.run(configuration)
        }


        return session
    }

}

extension ARSession {

    class Delegate: NSObject, ARSessionDelegate, Pipable {

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            pipe.put(anchors, key: [ARAnchor].Label.add.rawValue)

            //Waiting for some ARAnchor
            if pipe.expectations[ARAnchor.self|] != nil {

                anchors.forEach {
                    let key = type(of: $0)| + ARAnchor.With.add|
                    isPiped?.put($0, key: key)
                }

            }

        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            pipe.put(anchors, key: [ARAnchor].Label.update.rawValue)

            //Waiting for some ARAnchor
            if pipe.expectations[ARAnchor.self|] != nil {

                anchors.forEach {
                    let key = type(of: $0)| + ARAnchor.With.update|
                    isPiped?.put($0, key: key)
                }

            }

        }

        func session(_ session: ARSession, didFailWithError error: Error) {
            isPiped?.put(error)
        }

    }

}

@available(iOS 13.0, *)
extension ARView: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {
        Self()
    }


}
