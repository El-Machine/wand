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

#if !targetEnvironment(simulator)
#if canImport(CoreNFC)
import CoreNFC

import Wand
import XCTest

@available(macOS, unavailable)
@available(watchOS, unavailable)
@available(tvOS, unavailable)
@available(visionOS, unavailable)
class CoreNFC_Tests: XCTestCase {


    func test_NFCNDEFMessage_read() {
        let e = expectation()

        |.one { (stored: NFCNDEFMessage) in

            e.fulfill()

        }

        waitForExpectations(timeout: .default * 4)
    }

    func test_NFCNDEFMessage_lock() {
        let e = expectation()

        var lastWrited: Data?

        weak var wand: Wand!
        wand = |{ (stored: NFCNDEFMessage) in

            guard let record = stored.records.first else {
                print("Empty tag ‼️")
                return
            }


            let payload = record.payload
            guard payload != lastWrited else {
                print("Same tag 👉👈")
                return
            }

            wand | Ask<NFCNDEFTag>.one().lock { done in

                lastWrited = payload

                let content = record.wellKnownTypeURIPayload()?.absoluteString ?? ""
                print("Locked 🔒 " + content)
            }


        }

        waitForExpectations(timeout: .default * 4)
    }

    func test_NFCNDEFMessage_write() {
        let e = expectation()

        var lastWrited: Data?

        weak var wand: Wand!
        wand = |{ (stored: NFCNDEFMessage) in

            guard let record = stored.records.first else {
                print("Empty tag ‼️")
                return
            }

            let payload = record.payload
            guard payload != lastWrited else {
                print("Same tag 👉👈")
                return
            }

            let content = "https://el-machine.com/tool"
            let message: NFCNDEFMessage = content|
            wand | Ask<NFCNDEFTag>.one().write(message) { done in

                lastWrited = message.records.first?.payload

                print("Writed ✅ " + content)

                e.fulfill()

            }


        }

        waitForExpectations(timeout: .default * 4)
    }


}

#endif
#endif
