//
//  Codable_Tests.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe
import XCTest

class Codable_Tests: XCTestCase {

    @available(iOS 16.0, *)
    func test_Codable_Object() {
        let e = expectation()

        let path = "https://api.github.com/repositories/42"
        path | { (repo: Repo) in

            e.fulfill()

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_Codable_Array() {
        let e = expectation()

        let path = "https://api.github.com/repositories?q=ios"
        path | { (array: [Repo]) in

            e.fulfill()

        }

        waitForExpectations()
    }


}
