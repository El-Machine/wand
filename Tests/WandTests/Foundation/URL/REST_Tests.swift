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

import Wand
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
