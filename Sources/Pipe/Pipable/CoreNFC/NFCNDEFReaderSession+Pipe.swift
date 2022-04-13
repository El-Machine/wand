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

import CoreNFC

extension NFCNDEFReaderSession: Constructable {

    static func | (something: Any?, type: NFCNDEFReaderSession.Type) -> Self {
        let piped = something as? Pipable

        if let session: Self = piped?.isPiped?.get() {
            return session
        }

        let pipe = piped?.pipe ?? Pipe()

        let delegate = pipe.put(Delegate())
        let source = Self(delegate: delegate,
                          queue: nil,
                          invalidateAfterFirstRead: false) //while

        let message = something as? String ?? "Hold to know what it is 🧙🏾‍♂️"
        source.alertMessage = message
        pipe.put(source)

        return source
    }

}
extension NFCNDEFReaderSession {

    class Delegate: NSObject, NFCNDEFReaderSessionDelegate, Pipable {

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            isPiped?.put(error)
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {

            if let first = tags.first {
                isPiped?.put(first)
            }

            if tags.count > 1 {
                isPiped?.put(tags)
            }
        }

    }

}
