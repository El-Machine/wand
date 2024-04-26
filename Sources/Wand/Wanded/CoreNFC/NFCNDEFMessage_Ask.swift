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

/// Ask
///
/// |{ (message: NFCNDEFMessage) in
///
/// }
///
@available(iOS 13.0, *)
@available(macOS, unavailable)
extension NFCNDEFMessage: AskingNil, Wanded {

    @inline(__always)
    public 
    static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        //Save ask
        guard wand.answer(the: ask) else {
            return
        }

        //Request for a first time

        //Make request
        //.one
        wand | .Optional.once(ask.once) { (tag: NFCNDEFTag) in

            let session: NFCNDEFReaderSession = wand.get()!

            session.connect(to: tag) { (error: Error?) in

                guard wand.addIf(exist: error) == nil else {
                    session.restartPolling()
                    return
                }

                wand | .Optional.once(ask.once) { (status: NFCNDEFStatus) in

                    guard wand.addIf(exist: error) == nil else {
                        return
                    }

                    tag.readNDEF { message, error in

                        if let error = error as? NFCReaderError,
                           error.code != .ndefReaderSessionErrorZeroLengthMessage
                        {
                            wand.add(error as Error)
                        }

                        wand.add(message ?? NFCNDEFMessage(data: Data())!)

                    }

                }

            }

        }


    }

}

#endif
