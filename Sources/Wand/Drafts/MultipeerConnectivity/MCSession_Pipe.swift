//  Copyright © 2020-2022 Alex Kozin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2022 Alex Kozin
//

import MultipeerConnectivity.MCSession

//extension MCSession: Constructor {
//
//    static func | (piped: Any?, type: MCSession.Type) -> Self {
//        let pipe = (piped as? Pipable)?.pipe ?? Pipe()
//
//        let peer = piped as? MCPeerID ?? pipe.get()!
//        let identity = piped as? [Any] ?? pipe.get()
//        let encryption = piped as? MCEncryptionPreference ?? pipe.get()
//
//        let source = Self(peer: peer,
//                          securityIdentity: identity,
//                          encryptionPreference: encryption ?? .optional)
//        source.delegate = pipe.put(Delegate())
//        pipe.put(source)
//
//        return source
//    }
//
//    class Delegate: NSObject, MCSessionDelegate, Pipable {
//
//        func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//            isPiped?.put(state, key: peerID.displayName + "_MCSessionState")
//        }
//
//        func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//            isPiped?.put(peerID, key: "fromPeer")
//            isPiped?.put(peerID, key: peerID.displayName + "_Data")
//            isPiped?.put(data)
//        }
//
//        func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
//
//        func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
//
//        func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
//
//    }
//
//}
