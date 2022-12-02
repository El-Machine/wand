//
//  Employee.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation

import Pipe

public extension JSONplaceholderAPI {

    struct Post: Codable, JSONplaceholderAPI.Model {

        let id: Int?

        let userId: Int?
        let title: String?
        let body: String?

        init(id: Int? = nil,
             userId: Int? = nil,
             title: String? = nil,
             body: String? = nil) {

            self.id = id
            self.userId = userId
            self.title = title
            self.body = body
        }

    }

}

public extension JSONplaceholderAPI.Post {

    static func get<P, E>(_ expectation: Expect<E>, with piped: P, on pipe: Pipeline) {

        //https://jsonplaceholder.typicode.com/posts/42
        if let id = piped as? Int {

            let path = base + "posts/" + id|
            pipe.put(path)

        }

        requestData(from: pipe)
    }

    func post<P>(with piped: P, on pipe: Pipeline) {

        //dummy.restapiexample.com/api/v1/create
        let path = Self.base + "create"
        pipe.put(path)

        let body: Data = self|
        pipe.put(body)

        Self.requestData(from: pipe)
    }

    func put<P>(with piped: P, on pipe: Pipeline) {

        //dummy.restapiexample.com/api/v1/update/21
        let path = Self.base + "update/" + id|
        pipe.put(path)

        let body: Data = self|
        pipe.put(body)

        Self.requestData(from: pipe)
    }

}

//tic func get<P>(with piped: P, on pipe: Pipe) {
//
//    switch piped {
//
//            //api.github.com/repositories?q=ios
//        case let query as String:
//
//            let path = self.base + "repositories?q=" + query
//            pipe.put(path)
//
//            break
//
//            //api.github.com/repositories
//        default:
//
//            let path = base + "repositories"
//            pipe.put(path)
//
//            break
//
//    }
//
//    requestData(from: pipe)
//    }
