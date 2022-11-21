//
//  DummyRestAPI.swift
//  PipeTests
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

protocol DummyRestAPIModel: RestModel {


}

extension DummyRestAPIModel {

    static var basePath: String {
        "https://dummy.restapiexample.com/api/v1/"
    }

    static var headers: [String : String]? {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }

}
