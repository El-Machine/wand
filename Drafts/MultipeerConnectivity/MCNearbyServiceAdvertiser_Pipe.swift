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

import MultipeerConnectivity

//extension MCNearbyServiceAdvertiser: Constructor {
//    
//    static func | (piped: Any?, type: MCNearbyServiceAdvertiser.Type) -> Self {
//        let pipe = piped.pipe
//
//        let peer = (piped as? MCPeerID) ?? pipe.get()
//        let service = (piped as? String) ?? pipe.get(for: "serviceType")!
//        let source = Self(peer: peer,
//                          discoveryInfo: pipe.get(),
//                          serviceType: service)
//        source.delegate = pipe.put(Delegate())
//
//        return source
//    }
//
//}
//
//extension MCNearbyServiceAdvertiser: Asking {
//
//    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
//        (pipe.get() as Self).startAdvertisingPeer()
//    }
//}
//
//extension MCNearbyServiceAdvertiser {
//
//    class Delegate: NSObject, MCNearbyServiceAdvertiserDelegate, Pipable {
//
//        func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//            isPiped?.put(invitationHandler)
//            isPiped?.put(context)
//            isPiped?.put(peerID, key: MCPeerID.With.invitation.rawValue)
//        }
//
//        func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
//            isPiped?.put(error)
//        }
//
//    }
//
//}
