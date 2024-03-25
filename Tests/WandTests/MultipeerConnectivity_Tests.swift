//
//  toolburator_Tests.swift
//  toolburator_Tests
//
//  Created by Alex Kozin on 28.04.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import MultipeerConnectivity

import XCTest

class MultipeerConnectivity_Tests: XCTestCase {

    weak var session: MCSession?

    func test_MCNearbyServiceAdvertiser() throws {
        let name = "MACHINE_" + UIDevice.current.name
        let peer: MCPeerID = name|


        let advertiser: MCNearbyServiceAdvertiser = peer|

        advertiser | { (invitedBy: MCPeerID) in
            let pipe = peer.pipe

            let invitation: (Bool, MCSession?) -> Void = pipe.get()!

            guard let context: Data = pipe.get(),
                  let string = context| as String?,
                  string == "🪢"
            else {
                invitation(false, nil)
                return
            }

            let session: MCSession = peer|
            session | { (data: Data) in

            }

            invitation(true, session)
        }

//        peer | { (peer: MCPeerID) in
//
//        } as Void
    }

    func sendDataToCheck(with: MCSession) {
        let gift = "💐🎁💝🧧"
        try! session?.send(gift|,
                           toPeers: with.connectedPeers,
                           with: .reliable)
    }

    func startExpectingData(from session: MCSession) {
//        session | { data in
//
//        }
    }

}
