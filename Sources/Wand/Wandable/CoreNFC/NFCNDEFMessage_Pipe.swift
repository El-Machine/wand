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

        pipe | .every { (tag: NFCNDEFTag) in

            session.connect(to: tag) { (error: Error?) in

                guard pipe.putIf(exist: error) == nil else {
                    session.restartPolling()
                    return
                }

                pipe | .one { (status: NFCNDEFStatus) in

                    guard pipe.putIf(exist: error) == nil else {
                        return
                    }

                    tag.readNDEF { message, error in

                        if let error = error as? NFCReaderError,
                           error.code != .ndefReaderSessionErrorZeroLengthMessage
                        {
                            pipe.put(error as Error)
                        }

                        pipe.put(message ?? NFCNDEFMessage(data: Data())!)

                    }

                }.inner()

            }

        }.inner()

        pipe.addCleaner {
            session.invalidate()
        }

    }

}


#endif


