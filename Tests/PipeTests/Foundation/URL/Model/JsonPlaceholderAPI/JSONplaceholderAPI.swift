//
//  DummyRestAPI.swift
//  PipeTests
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

public struct JSONplaceholderAPI {

    public typealias Model = JSONplaceholderAPI_Model
    
}

public protocol JSONplaceholderAPI_Model: Rest.Model {

}

public extension JSONplaceholderAPI_Model {

    static var base: String? {
        "https://jsonplaceholder.typicode.com/"
    }

    static var headers: [String : String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }

}
