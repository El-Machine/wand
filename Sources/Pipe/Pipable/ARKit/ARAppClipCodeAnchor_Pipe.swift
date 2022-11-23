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

@available(iOS 13.0, *)
extension Array: Expectable where Element == ARAnchor {

}

@available(iOS 13.0, *)
extension Array: ExpectableLabeled, ExpectableWithout where Element == ARAnchor {

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {

        let key = expectation.key
        guard pipe.start(expecting: expectation, key: key) else {
            return
        }

        let session = (piped as? ARSession) ?? pipe.get()

        expectation.cleaner = {
            session.pause()
        }

    }


}

@available(iOS 13.0, *)
public extension Expect where T == Array<ARAnchor> {

    static func add(_ handler: ( (T)->() )? = nil) -> Self {
        Expect.every(#function, handler) as! Self
    }

    static func update(_ handler: ( (T)->() )? = nil) -> Self {
        Expect.every(#function, handler) as! Self
    }

    static func remove(_ handler: ( (T)->() )? = nil) -> Self {
        Expect.every(#function, handler) as! Self
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

@available(iOS 13.0, *)
extension ARSession {

    class Delegate: NSObject, ARSessionDelegate, Pipable {

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            let key = Expect<[ARAnchor]>.add().key

            pipe.put(anchors, key: key)

            //Waiting for some ARAnchor
            if pipe.expectations[ARAnchor.self|] != nil {

                anchors.forEach {
                    let typed = type(of: $0)| + key
                    isPiped?.put($0, key: typed)
                }

            }

        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            pipe.put(anchors, key: Expect<[ARAnchor]>.update().key)

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
