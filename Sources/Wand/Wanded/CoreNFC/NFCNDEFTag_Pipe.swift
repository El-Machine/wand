/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

#if canImport(CoreNFC)
import CoreNFC

//AskingNil
@inline(__always)
@available(iOS 13.0, *)
@discardableResult
public prefix func | (handler: @escaping (NFCNDEFTag)->() ) -> Wand {
    nil | Ask.every(handler: handler)
}

@inline(__always)
@available(iOS 13.0, *)
@discardableResult
public prefix func | (ask: Ask<NFCNDEFTag>) -> Wand {
    nil | ask
}


@inline(__always)
@available(iOS 13.0, *)
@discardableResult
public func | (pipe: Pipe?, ask: Ask<NFCNDEFTag>) -> Wand {
    (pipe ?? Pipe()) as Any | ask
}

//Asking
@inline(__always)
@available(iOS 13.0, *)
@discardableResult
public func |<S> (scope: S, handler: @escaping (NFCNDEFTag)->() ) -> Wand {
    scope | Ask.every(handler: handler)
}

@inline(__always)
@available(iOS 13.0, *)
@discardableResult
public func |<S> (scope: S, ask: Ask<NFCNDEFTag>) -> Wand {
    let pipe = Wand.attach(to: scope)

    guard pipe.answer(the: ask, check: true) else {
        return pipe
    }

    let session: NFCNDEFReaderSession = pipe.obtain()
    session.alertMessage = pipe.get() ?? ""
    session.begin()

    pipe.setCleaner(for: NFCNDEFTag.self) {
        session.invalidate()
    }

    return pipe
}

@available(iOS 13.0, *)
extension NFCNDEFTag {

    var wand: Wand {
        isWanded ?? Wand(for: self)
    }

    var isWanded: Wand? {
        Wand[self]
    }

}

@available(iOS 13.0, *)
extension Ask where T == NFCNDEFTag {

    @available(iOS 13.0, *)
    public func write (_ message: NFCNDEFMessage, done: @escaping (NFCNDEFTag)->() ) -> Self {

//        let oldHandler = self.handler
//
//        self.handler = { tag in
//
//            let pipe = tag.pipe
//
//            let session: NFCNDEFReaderSession = pipe.get()
//            
//            session.connect(to: tag) { (error: Error?) in
//
//                guard pipe.putIf(exist: error) == nil else {
//                    return
//                }
//
//                pipe | .one { (status: NFCNDEFStatus) in
//
//                    switch status {
//
//                        case .readWrite:
//
//                            let message = message
//
//                            let capacity: Int = pipe.get()!
//                            if message.length > capacity {
//
//                                let e = Pipe.Error.nfc("Tag capacity is too small. Minimum size requirement is \(message.length) bytes.")
//                                pipe.put(e)
//
//                                return
//                            }
//
//                            tag.writeNDEF(message) { (error: Error?) in
//
//                                guard pipe.putIf(exist: error) == nil else {
//                                    return
//                                }
//
//                                done(tag)
//
//                            }
//
//                        case .readOnly:
//                            let e = Pipe.Error.nfc("Tag is not writable")
//                            pipe.put(e)
//
//                        case .notSupported:
//                            let e = Pipe.Error.nfc("Tag is not NDEF")
//                            pipe.put(e)
//
//                        @unknown default:
//                            fatalError()
//
//                    }
//
//                }.inner()
//                
//            }
//
//            //Call previous handler
//            return oldHandler(tag)
//        }

        return self
    }

    @available(iOS 13.0, *)
    public func lock (done: @escaping (NFCNDEFTag)->() ) -> Self {

        let oldHandler = self.handler

//        self.handler = { tag in
//
//            let pipe = tag.pipe
//
//            let session: NFCNDEFReaderSession = pipe.get()
//
//            session.connect(to: tag) { (error: Error?) in
//
//                guard pipe.putIf(exist: error) == nil else {
//                    return
//                }
//
//                tag.writeLock { error in
//
//                    if let error = error as? NFCReaderError {
//
//                        switch error.code {
//                            case .ndefReaderSessionErrorTagUpdateFailure:
//
//                                let e = Pipe.Error.nfc("Already locked tag 🦾\n")
//                                pipe.put(e)
//
//                            default:
//                                pipe.put(error as Error)
//                        }
//
//
//                        return
//                    }
//
//                    done(tag)
//                }
//
//            }
//
//            //Call previous handler
//            return oldHandler(tag)
//        }

        return self
    }

}

#endif
