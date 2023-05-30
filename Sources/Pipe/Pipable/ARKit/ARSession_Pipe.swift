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

        //TODO: Create ARView if no?
        let arView: ARView = pipe.get()

        let session: Self = arView.session as! Self
        session.delegate = pipe.put(Delegate())

        if let configuration: ARConfiguration = pipe.get() {
            arView.automaticallyConfigureSession = false
            session.run(configuration)
        }


        return pipe.put(session)
    }

}

@available(iOS 13.0, *)
extension ARSession {

    class Delegate: NSObject, ARSessionDelegate, Pipable {

        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {

            guard let pipe = isPiped else {
                return
            }

            let key = Ask<[ARAnchor]>.add().key!
            pipe.put(anchors, key: key)

            //Waiting for some ARAnchor
            if pipe.asking[ARAnchor.self|] != nil {

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

            let key = Ask<[ARAnchor]>.update().key!
            pipe.put(anchors, key: key)

            //Waiting for some ARAnchor
            if pipe.asking[ARAnchor.self|] != nil {

                anchors.forEach {
                    let key = type(of: $0)| + key
                    isPiped?.put($0, key: key)
                }

            }

        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            isPiped?.put(frame)
        }

        func session(_ session: ARSession, didFailWithError error: Error) {
            isPiped?.put(error)
        }

    }

}
