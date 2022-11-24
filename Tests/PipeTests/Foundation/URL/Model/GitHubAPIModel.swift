//
//  DummyRestAPI.swift
//  PipeTests
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

public protocol GitHubAPIModel: RestModel {

}

public extension GitHubAPIModel {

    static var base: String {
        "https://api.github.com/"
    }

    static var headers: [String : String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }

}
