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
extension NFCNDEFStatus: AskingNil, Wanded {

    public static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        //Save ask
        guard wand.answer(the: ask, check: true) else {
            return
        }

        //Request for a first time

        //Prepare context
        let session: NFCNDEFReaderSession = wand.obtain()

        //Set the cleaner
        wand.setCleaner(for: ask) {
            session.invalidate()

            Wand.log("|🌜 Cleaned '\(ask.key)'")
        }

        //Make request
        //.one
        wand | .Optional.every { (tag: NFCNDEFTag) in

            session.connect(to: tag) { (error: Error?) in

                guard wand.addIf(exist: error) == nil else {
                    session.restartPolling()
                    return
                }

                tag.queryNDEFStatus() { (status: NFCNDEFStatus, capacity: Int, error: Error?) in

                    guard wand.addIf(exist: error) == nil else {
                        return
                    }

                    wand.add(capacity)
                    wand.add(status)

                }

            }

        }

    }

}

#endif


