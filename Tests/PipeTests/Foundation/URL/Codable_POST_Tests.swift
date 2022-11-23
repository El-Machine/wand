//
//  Codable_Tests.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe
import XCTest

class Codable_POST_Tests: XCTestCase {

    @available(iOS 16.0, *)
    func test_POST_Codable() {
        let e = expectation()

        let employee = Employee(age: 33,
                                name: "Oleg",
                                salary: 1024)

        employee | .post { (done: Employee) in

            e.fulfill()

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_PUT_Codable() {
        let e = expectation()

        let employee = Employee(id: 42,
                                salary: 2048)

        employee | .put { (done: Employee) in

            e.fulfill()

        }

        waitForExpectations()
    }


}
