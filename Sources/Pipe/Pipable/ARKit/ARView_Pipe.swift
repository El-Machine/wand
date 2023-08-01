//
//  ARSession_Pipe.swift
//  Pipe
//
//  Created by Alex Kozin on 20.10.2022.
//

import RealityKit

@available(iOS 13.0, *)
extension ARView: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        Self()
    }

}
