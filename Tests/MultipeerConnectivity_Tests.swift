/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

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
