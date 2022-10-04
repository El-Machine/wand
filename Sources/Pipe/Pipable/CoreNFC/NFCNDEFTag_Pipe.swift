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

@available(iOS 13.0, *)
@discardableResult
public prefix func | (handler: @escaping (NFCNDEFTag)->() ) -> Pipe {
    |.every(handler)
}

@available(iOS 13.0, *)
public func |(pipe: Pipe?, handler: @escaping (NFCNDEFTag)->() ) -> Pipe {
    (pipe ?? Pipe()) as Any | .every(handler)
}

@available(iOS 13.0, *)
@discardableResult
public func |<P> (piped: P, handler: @escaping (NFCNDEFTag)->() ) -> Pipe {
    piped | .every(handler)
}

@available(iOS 13.0, *)
@discardableResult
public prefix func |(expectation: Expect<NFCNDEFTag>) -> Pipe {
    Pipe() | expectation
}

@available(iOS 13.0, *)
@discardableResult
public func |(pipe: Pipe?, expectation: Expect<NFCNDEFTag>) -> Pipe {
    (pipe ?? Pipe()) as Any | expectation
}

@available(iOS 13.0, *)
@discardableResult
public func |<P> (piped: P, expectation: Expect<NFCNDEFTag>) -> Pipe {
    let pipe = Pipe.attach(to: piped)

    guard pipe.start(expecting: expectation) else {
        return pipe
    }

    let source = piped as? NFCNDEFReaderSession ?? pipe.get()
    source.alertMessage = piped as? String ?? pipe.get() ?? ""
    source.begin()

    expectation.cleaner = {
        source.invalidate()
    }

    return pipe
}

@available(iOS 13.0, *)
extension NFCNDEFTag {

    var pipe: Pipe {
        isPiped ?? Pipe(object: self)
    }

    var isPiped: Pipe? {
        Pipe[self]
    }

}


@available(iOS 13.0, *)
extension NFCNDEFMessage: ExpectableWith, Pipable {

    public typealias With = NFCNDEFTag

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) where E : Expectable {

        guard pipe.start(expecting: expectation) else {
            return
        }

        let tag = piped as? NFCNDEFTag ?? pipe.get()!

        let session: NFCNDEFReaderSession = pipe.get()
        session.connect(to: tag) { (error: Error?) in
            if error != nil {
                session.restartPolling()
                return
            }


            tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in

                if let error {
                    pipe.put(error)
                    return
                }

//                if error != nil {
//                    session.invalidate(errorMessage: "Fail to determine NDEF status.  Please try again.")
//                    return
//                }

                tag.readNDEF { message, error in

                    if let error {
                        pipe.put(error)
                        return
                    }

                    if let message {
                        pipe.put(message)
                    }

                }


            }
        }

    }

}

extension Result: Expectable {

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) where E : Expectable {
    }


}

@available(iOS 13.0, *)
public func | (tag: NFCNDEFTag, message: NFCNDEFMessage) -> Pipe {

    let pipe = tag.pipe

//    guard pipe.start(expecting: Result<Int, Error>.one) else {
//        return pipe
//    }

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
                    pipe.put(error)
                }
            } else {
                session.invalidate(errorMessage: "Tag is not NDEF formatted.")
            }
        }
    }

    return pipe
}

#endif
