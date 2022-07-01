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


postfix func | (piped: String) -> MCPeerID {
    MCPeerID(displayName: piped)
}


protocol Expects: Pipable {

}


import MultipeerConnectivity

extension MCPeerID: Pipable {

}

//    static func ask<T>(with: Any?, in pipe: Pipe, expect: Expect<T>) {
//        let source: MCNearbyServiceAdvertiser = pipe.get()
//        source.startAdvertisingPeer()
//    }
//
//    @discardableResult
//    static func | (piped: MCPeerID, expects: MCPeerID) -> MCNearbyServiceBrowser {
//        let pipe = piped.pipe
//
//        let peer = piped// as? MCPeerID ?? pipe.get()!
//        let source: MCNearbyServiceBrowser = peer|
//        produce(with: source, on: pipe, expects: MCPeerID.self)
//
//        return source
//    }
//
//    static func ask<T>(with: MCNearbyServiceBrowser, in pipe: Pipe, expects: T) {
//        with.startBrowsingForPeers()
//    }
//
//}

