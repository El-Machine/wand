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

import MultipeerConnectivity.MCNearbyServiceBrowser

//extension MCNearbyServiceBrowser: Constructor {
//
//    static func |(piped: Any?, type: MCNearbyServiceBrowser.Type) -> Self {
//        let pipe = piped.pipe
//
//        let peer = piped as? MCPeerID ?? pipe.get()
//        let service: String = pipe.get(for: "serviceType")!
//
//        let source = Self(peer: peer, serviceType: service)
//        source.delegate = pipe.put(Delegate())
//        return source
//    }
//
//}
//
//extension MCNearbyServiceBrowser: Asking {
//
//        static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
//            (pipe.get() as Self).startBrowsingForPeers()
//        }
//    }
//
//extension MCNearbyServiceBrowser {
//
//    class Delegate: NSObject, MCNearbyServiceBrowserDelegate, Pipable {
//
//        func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//            if let info = info {
//                isPiped?.put(info)
//            }
//            isPiped?.put(peerID, key: MCPeerID.With.found.rawValue)
//        }
//
//        func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//            isPiped?.put(peerID, key: "lostPeer")
//        }
//
//    }
//
//}
