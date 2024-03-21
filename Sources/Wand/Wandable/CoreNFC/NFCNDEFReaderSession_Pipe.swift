//  Copyright © 2020-2022 El Machine 🤖
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
//

#if canImport(CoreNFC)
import CoreNFC

extension NFCNDEFReaderSession: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let delegate = pipe.put(Delegate())

        let source = Self(delegate: delegate,
                          queue: DispatchQueue.global(),
                          invalidateAfterFirstRead: false) //while

        let message: String = pipe.get() ?? "Hold to know what it is 🧙🏾‍♂️"
        source.alertMessage = message

        pipe.put(source)

        return pipe.put(source)
    }

}
extension NFCNDEFReaderSession {

    class Delegate: NSObject, NFCNDEFReaderSessionDelegate, Pipable {

        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            isPiped?.put(true as Bool, key: "NFCNDEFReaderSessionIsReady")
        }

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            isPiped?.put(false as Bool, key: "NFCNDEFReaderSessionIsReady")
            isPiped?.put(error)
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        }

        @available(iOS 13.0, *)
        func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {

            if let first = tags.first {
//                isPiped?.put(first)
                
                if let pipe = isPiped {



                    let address = MemoryAddress.address(of: first)
                    print("💪🏽 set \(address)")
                    Pipe.all[address] = pipe

                    pipe.put(first)
                }
            }

//            if tags.count > 1 {
//                isPiped?.put(tags)
//            }
        }

    }

}

#endif
