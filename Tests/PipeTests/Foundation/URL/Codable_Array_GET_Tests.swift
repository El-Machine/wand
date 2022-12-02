//
//  Codable_Tests.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe
import XCTest

class Codable_Array_GET_Tests: XCTestCase {

    @available(iOS 16.0, *)
    func test_any_Codable_Array() {
        let e = expectation()

        |{ (result: [GitHubAPI.Repo]) in

            if !result.isEmpty {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_argument_Codable_Array() {
        let e = expectation()

        let query = "ios"
        query | { (result: [GitHubAPI.Repo]) in

            if !result.isEmpty {
                e.fulfill()
            }

        }

        waitForExpectations()
    }




//    @available(iOS 16.0, *)
//    func test_Path_Codable_Array() {
//        let e = expectation()
//
//        let path = "https://api.github.com/repositories?q=ios"
//        path | { (array: [Repo]) in
//
//            e.fulfill()
//
//        }
//
//        waitForExpectations()
//    }
//
//    @available(iOS 16.0, *)
//    func test_URL_Codable_Array() {
//        let e = expectation()
//
//        let path = "https://api.github.com/repositories?q=ios"
//        let url = URL(string: path)
//        url | { (array: [Repo]) in
//
//            e.fulfill()
//
//        }
//
//        waitForExpectations()
//    }


}
