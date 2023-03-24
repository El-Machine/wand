//
//  Codable_Tests.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe
import XCTest

class REST_Tests: XCTestCase {

    @available(iOS 16.0, *)
    func test_Argument_to_REST_Codable() {
        let e = expectation()

        let id = 52

        id | .get { (repo: GitHubAPI.Repo) in

            if repo.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_Path_to_REST_Codable() {
        let e = expectation()

        let id = 42
        let path = "https://api.github.com/repositories/\(id)"

        path | .get { (repo: GitHubAPI.Repo) in

            if repo.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_REST_Codable_Post() {
        let e = expectation()

        let id = (1...100).any

        let post = JSONplaceholderAPI.Post(id: id,
                                           userId: .any,
                                           title: .any,
                                           body: .any)
        post | .post { (done: JSONplaceholderAPI.Post) in

            if done.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_REST_Codable_Put() {
        let e = expectation()

        let id = (1...100).any

        let post = JSONplaceholderAPI.Post(id: id,
                                           userId: .any,
                                           title: .any,
                                           body: nil)
        post | .put { (done: JSONplaceholderAPI.Post) in

            if done.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_REST_Codable_Delete() {
        let e = expectation()

        let id = (1...100).any

        let post = JSONplaceholderAPI.Post(id: id,
                                           userId: .any,
                                           title: nil,
                                           body: nil)
        post | .delete { (done: JSONplaceholderAPI.Post) in

            if done.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

}
