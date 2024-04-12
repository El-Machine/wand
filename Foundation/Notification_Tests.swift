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

import Foundation

import Wand
import XCTest


private
extension Notification.Name {

    static var custom = Self.init(String())

}

class Notification_Tests: XCTestCase {


    func test_Notification_custom() {
        let e = expectation()

        let name = Notification.Name.custom

        name | .one { n in
            e.fulfill()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            NotificationCenter.default.post(Notification(name: name))

        }

        waitForExpectations()
    }

//    func test_Notification_memory() {
//        let e = expectation()
//
//        //Simulate Memory Warning
//        //⌘+⇧+M
//        UIApplication.didReceiveMemoryWarningNotification | .one { n in
//            e.fulfill()
//        }
//
//        waitForExpectations()
//    }
//
//    func test_WhileNotification() {
//        let e = expectation()
//        e.expectedFulfillmentCount = 2
//
//        //Simulate Memory Warning
//        //⌘+⇧+M
//        UIApplication.didReceiveMemoryWarningNotification | .while { (notification, i) in
//            e.fulfill()
//
//            print(notification)
//
//            return i < 2
//        }
//
//        waitForExpectations()
//    }

}
