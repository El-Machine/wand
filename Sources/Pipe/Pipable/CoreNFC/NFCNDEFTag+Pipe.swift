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

@discardableResult
prefix func |(handler: @escaping (NFCNDEFTag)->()) -> Pipe {
    |.every(handler: handler)
}

prefix func |<H: Pipable>(handler: @escaping (NFCNDEFTag)->()) -> H? {
    (|handler).get()
}

//
@discardableResult
prefix func |(event: Event<NFCNDEFTag>) -> Pipe {
    Pipe().expect(event, with: nil, producer: NFCNDEFTagProducer.self)
}

prefix func |<H>(event: Event<NFCNDEFTag>) -> H? {
    (|event).get()
}

//
@discardableResult
func |(piped: Any?, handler: @escaping (NFCNDEFTag)->()) -> Pipe {
    piped | .every(handler: handler)
}

func |<H> (piped: Any?, handler: @escaping (NFCNDEFTag)->()) -> H? {
    (piped | handler).get()
}

//
@discardableResult
func |(piped: Any?, event: Event<NFCNDEFTag>) -> Pipe {
    ((piped as? Pipable)?.pipe ?? Pipe()).expect(event,
                                                 with: piped,
                                                 producer: NFCNDEFTagProducer.self)
}

func |<H> (piped: Any?, event: Event<NFCNDEFTag>) -> H? {
    (piped | event).get()
}

//
func |(piped: NFCNDEFTag, handler: @escaping (NFCNDEFMessage?)->()) {
    piped.readNDEF { message, _ in
        handler(message)
    }
}



struct NFCNDEFTagProducer: Producer {

    static func produce<T>(with: Any?, on pipe: Pipe, expecting: Event<T>) {
        let source = with as? NFCNDEFReaderSession ?? pipe.get()
        source.alertMessage = ""
        source.begin()

        expecting.cleaner = {
            source.invalidate()
        }
    }

}

extension NFCNDEFMessage: Pipable {

}

func | (piped: NFCNDEFReaderSession, message: NFCNDEFMessage) -> NFCNDEFMessage {
    let session = piped

    let pipe = session.pipe
    let tag = (piped as? NFCNDEFTag) ?? pipe.get()!

    pipe.put(message)

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
