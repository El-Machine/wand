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

extension NFCNDEFReaderSession: AskingNil {

    @inline(__always)
    public 
    static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        //Save ask
        guard wand.answer(the: ask) else {
            return
        }

        //Request for a first time

        //Prepare context
        let delegate = wand.add(Delegate())

        let session = Self(delegate: delegate,
                          queue: DispatchQueue.global(),
                          invalidateAfterFirstRead: false)

        let message: String = wand.get() ?? "Hold to know what it is 🧙🏾‍♂️"
        session.alertMessage = message

        //Set the cleaner
        wand.setCleaner(for: ask) {
            session.invalidate()

            Wand.log("|🌜 Cleaned '\(ask.key)'")
        }

        wand.add(session)

        //Make request
        session.begin()
    }

}
extension NFCNDEFReaderSession {

    class Delegate: NSObject, NFCNDEFReaderSessionDelegate, Wanded {

        func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
            isWanded?.add(true as Bool, for: "NFCNDEFReaderSessionIsReady")
        }

        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            isWanded?.add(false as Bool, for: "NFCNDEFReaderSessionIsReady")
            isWanded?.add(error)
        }

        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        }

        @available(iOS 13.0, *)
        func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {

            if let first = tags.first {
//                isPiped?.put(first)
                
                if let wand = isWanded {



//                    let address = MemoryAddress.address(of: first)
//                    print("💪🏽 set \(address)")
//                    Pipe.all[address] = pipe


                    Wand.all[Wand.address(for: first)] = Wand.Weak(item: wand)
//                    context[NFCNDEFTag.self|] = object

                    wand.add(first)
                }
            }

//            if tags.count > 1 {
//                isPiped?.put(tags)
//            }
        }

    }

}

#endif
