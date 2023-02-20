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
extension NFCNDEFMessage: AskingWithout, Pipable {

    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {

        guard pipe.ask(for: ask) else {
            return
        }

        let session: NFCNDEFReaderSession = pipe.get()

        pipe | Ask.every { (tag: NFCNDEFTag) in

            session.connect(to: tag) { (error: Error?) in

                guard pipe.putIf(exist: error) == nil else {
                    session.restartPolling()
                    return
                }

                pipe | { (status: NFCNDEFStatus) in

                    guard pipe.putIf(exist: error) == nil else {
                        return
                    }

                    tag.readNDEF { message, error in

                        guard pipe.putIf(exist: error) == nil else {
                            return
                        }

                        pipe.put(message!)

                    }

                }

            }

        }.inner()

        pipe.addCleaner {
            session.invalidate()
        }

    }

}

@available(iOS 13.0, *)
extension NFCNDEFStatus: AskingWithout, Pipable {

    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {

        guard pipe.ask(for: ask) else {
            return
        }

        let session: NFCNDEFReaderSession = pipe.get()

        pipe | .every { (tag: NFCNDEFTag) in

            session.connect(to: tag) { (error: Error?) in

                guard pipe.putIf(exist: error) == nil else {
                    session.restartPolling()
                    return
                }

                tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in

                    guard pipe.putIf(exist: error) == nil else {
                        return
                    }

                    pipe.put(capacity)
                    pipe.put(status)
                }

            }

        }.inner()

        pipe.addCleaner {
            session.invalidate()
        }

    }


}

//@available(iOS 13.0, *)
//public func | (tag: NFCNDEFTag, message: NFCNDEFMessage) -> Pipe {
//
//    let pipe = tag.pipe
//
//    let session: NFCNDEFReaderSession = pipe.get()
//    session.connect(to: tag) { (error: Error?) in
//        if error != nil {
//            session.restartPolling()
//            return
//        }
//
//        // You then query the NDEF status of tag.
//        tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in
//            if error != nil {
//                session.invalidate(errorMessage: "Fail to determine NDEF status.  Please try again.")
//                return
//            }
//
//            if status == .readOnly {
//                session.invalidate(errorMessage: "Tag is not writable.")
//            } else if status == .readWrite {
//                if message.length > capacity {
//                    session.invalidate(errorMessage: "Tag capacity is too small.  Minimum size requirement is \(message.length) bytes.")
//                    return
//                }
//
//                // When a tag is read-writable and has sufficient capacity,
//                // write an NDEF message to it.
//                tag.writeNDEF(message) { (error: Error?) in
//                    pipe.put(error)
//                }
//            } else {
//                session.invalidate(errorMessage: "Tag is not NDEF formatted.")
//            }
//        }
//    }
//
//    return pipe
//}

extension NFCNDEFMessage {



//        public static func ask(_ expectation: Expect<NFCNDEFMessage>,
//                               from pipe: Pipe) {
//
//            //Add expectation
//            guard pipe.expect(expectation) else {
//                return
//            }
//
//            //Ask only first time
//
//            //Require tag
//            let tag: NFCNDEFTag                 = pipe.get()!
//            let session: NFCNDEFReaderSession   = pipe.get()
//
//            session.connect(to: tag) { (error: Error?) in
//
//                guard pipe.putIf(exist: error) == nil else {
//                    return
//                }
//
//                tag | .one { (status: NFCNDEFStatus) in
//
//                    guard pipe.putIf(exist: error) == nil else {
//                        return
//                    }
//
//                    tag.readNDEF { message, error in
//
//                        guard pipe.putIf(exist: error) == nil else {
//                            return
//                        }
//
//                        pipe.put(message!)
//
//                    }
//
//                }
//
//            }
//
//        }
//
//    }

    struct Operations {

        @available(iOS 13.0, *)
        public static func write(_ message: NFCNDEFMessage, handler: @escaping ()->() ) -> Pipe {

            let pipe = Pipe() //Pipe?

            let tag: NFCNDEFTag                 = pipe.get()!
            let session: NFCNDEFReaderSession   = pipe.get()

            session.connect(to: tag) { (error: Error?) in

                guard pipe.putIf(exist: error) == nil else {
                    return
                }

                tag | .one { (status: NFCNDEFStatus) in

                    switch status {

                        case .readWrite:

                            let capacity: Int = pipe.get()!
                            if message.length > capacity {

                                pipe.put(NFCReaderError("Tag capacity is too small. Minimum size requirement is \(message.length) bytes."))

                                return
                            }

                            tag.writeNDEF(message) { (error: Error?) in

                                guard pipe.putIf(exist: error) == nil else {
                                    return
                                }

                                handler()

                            }

                        case .readOnly:
                            pipe.put(NFCReaderError("Tag is not writable"))

                        case .notSupported:
                            pipe.put(NFCReaderError("Tag is not NDEF formatted"))

                        @unknown default:
                            fatalError()

                    }

                }
            }

            return pipe
        }

    }

}


extension NFCReaderError {

    init(_ message: String) {
        self.init(.readerErrorInvalidParameter,
                  userInfo: [NSLocalizedDescriptionKey: message])
    }

}


#endif


