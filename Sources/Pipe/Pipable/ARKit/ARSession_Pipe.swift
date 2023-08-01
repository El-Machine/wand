//
//  ARSession_Pipe.swift
//  Pipe
//
//  Created by Alex Kozin on 20.10.2022.
//

import ARKit.ARSession
import RealityKit

@available(iOS 13.0, *)
extension ARSession: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let arView: ARView = pipe.get()

        let session: Self = arView.session as! Self
        session.delegate = pipe.put(ARSession.Delegate())

        if let configuration: ARConfiguration = pipe.get() {
            arView.automaticallyConfigureSession = false
            session.run(configuration)
        }


        return session
    }

    class Delegate: NSObject, ARSessionDelegate, Pipable {

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            let key: String = Ask<[ARAnchor]>.DidAdd.self|
            pipe.put(anchors, key: key)
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            let key: String = Ask<[ARAnchor]>.DidUpdate.self|
            pipe.put(anchors, key: key)
        }

        func session(_ session: ARSession, didFailWithError error: Error) {
            isPiped?.put(error)
        }

    }

}
