//
//  Codable_Tests.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe
import XCTest

class Codable_GET_Tests: XCTestCase {

    @available(iOS 16.0, *)
    func test_argument_Codable() {
        let e = expectation()

        let id = 52

        id | { (repo: GitHubAPI.Repo) in

            if repo.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_Path_Codable() {
        let e = expectation()

        let id = 42
        let path = "https://api.github.com/repositories/\(id)"

        path | { (repo: GitHubAPI.Repo) in

            if repo.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

    @available(iOS 16.0, *)
    func test_URL_Codable() {
        let e = expectation()

        let id = (1...100).any
        let path = "https://jsonplaceholder.typicode.com/posts/\(id)"
        let url = URL(string: path)

        url | { (post: JSONplaceholderAPI.Post) in

            if post.id == id {
                e.fulfill()
            }

        }

        waitForExpectations()
    }

}
