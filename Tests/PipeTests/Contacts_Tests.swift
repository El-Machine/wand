//  Copyright (c) 2020-2021 El Machine (http://el-machine.com/)
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
//  2020 El Machine
//

import Contacts

import Pipe
import XCTest

class Contacts_Tests: XCTestCase {
    
    func test_CNContact() {
        let e = expectation()

        |.one { (contact: CNContact) in
            e.fulfill()
        }

        waitForExpectations()
    }

    func test_CNContact_Predicate() {
        let e = expectation()

        CNContact.predicateForContacts(matchingName: "John Appleseed") | Ask.every { (contact: CNContact) in

            //Only one John Appleseed exist!
            e.fulfill()

        }

        waitForExpectations()
    }

    func test_CNContact_Predicate_Keys() {
        let e = expectation()


        let predicate = CNContact.predicateForContacts(matchingName: "John Appleseed")
        let keys: [CNKeyDescriptor] = [CNContactFamilyNameKey as NSString]

         [predicate, keys] | Ask.every { (contact: CNContact) in

            //Only one John Appleseed exist!
            if contact.familyName == "Appleseed" {
                e.fulfill()
            }
        }

        waitForExpectations()
    }

    func test_CNContactStore() {
        XCTAssertNotNil(CNContactStore.self|)
    }

}
