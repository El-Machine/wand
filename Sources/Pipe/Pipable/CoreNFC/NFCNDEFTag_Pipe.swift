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

@discardableResult
@available(iOS 13.0, *)
func |(piped: Any?, event: Expect<NFCNDEFTag>) -> Pipe {
    ((piped as? Pipable)?.pipe ?? Pipe()).add(event,
                                              with: piped,
                                              asking: NFCNDEFTagAsking.self)
}

@available(iOS 13.0, *)
func |(piped: NFCNDEFTag, handler: @escaping (NFCNDEFMessage?)->() ) {
    piped.readNDEF { message, _ in
        handler(message)
    }
}

struct NFCNDEFTagAsking: Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        let source = with as? NFCNDEFReaderSession ?? pipe.get()
        source.alertMessage = ""
        source.begin()

        expect.cleaner = {
            source.invalidate()
        }
    }

}

extension NFCNDEFMessage: Pipable {

}

@available(iOS 13.0, *)
func | (tag: NFCNDEFTag, message: NFCNDEFMessage) -> NFCNDEFMessage {
    let pipe = message.pipe

    let session: NFCNDEFReaderSession = pipe.get()
    session.connect(to: tag) { (error: Error?) in
        if error != nil {
            session.restartPolling()
            return
        }

        // You then query the NDEF status of tag.
        tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
            if error != nil {
                session.invalidate(errorMessage: "Fail to determine NDEF status.  Please try again.")
                return
            }

            if status == .readOnly {
                session.invalidate(errorMessage: "Tag is not writable.")
            } else if status == .readWrite {
                if message.length > capacity {
                    session.invalidate(errorMessage: "Tag capacity is too small.  Minimum size requirement is \(message.length) bytes.")
                    return
                }

                // When a tag is read-writable and has sufficient capacity,
                // write an NDEF message to it.
                tag.writeNDEF(message) { (error: Error?) in
                    if error != nil {
                        session.invalidate(errorMessage: "Update tag failed. Please try again.")
                    } else {
                        pipe.put(Result<Int, Error>.success(0))
                    }
                }
            } else {
                session.invalidate(errorMessage: "Tag is not NDEF formatted.")
            }
        }
    }

    return message
}

#endif
