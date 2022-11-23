//
//  DummyRestAPI.swift
//  PipeTests
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

public protocol DummyRestAPIModel: Rest.Model {

}

public extension DummyRestAPIModel {

    static var base: String {
        "https://dummy.restapiexample.com/api/v1/"
    }

    static var headers: [String : String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }

}
