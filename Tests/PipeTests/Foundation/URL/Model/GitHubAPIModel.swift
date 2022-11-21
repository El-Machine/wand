//
//  DummyRestAPI.swift
//  PipeTests
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

protocol GitHubAPIModel: RestModel {

}

extension GitHubAPIModel {

    static var basePath: String {
        "https://api.github.com/"
    }

    static var headers: [String : String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }

}
