//
//  DummyRestAPI.swift
//  PipeTests
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

public struct GitHubAPI {

    public typealias Model = GitHubAPI_Model

}

public protocol GitHubAPI_Model: Rest.Model {

}

public extension GitHubAPI_Model {

    static var base: String? {
        "https://api.github.com/"
    }

    static var headers: [String : String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }

}
