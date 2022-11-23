//
//  Employee.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

import Foundation

struct Employee: DummyRestAPIModel {

    let id: Int?

    let age: Int?
    let name: String?
    let salary: Int?

    init(id: Int? = nil,
         age: Int? = nil,
         name: String? = nil,
         salary: Int? = nil) {

        self.id = id
        self.age = age
        self.name = name
        self.salary = salary
    }

    func post<P>(with piped: P, on pipe: Pipeline) {

        //dummy.restapiexample.com/api/v1/create

        let path = Self.base + "create"
        pipe.put(path)

        let body: Data = self|
        pipe.put(body)

    }

    func put<P>(with piped: P, on pipe: Pipeline) {

        //dummy.restapiexample.com/api/v1/update/21

        let path = Self.base + "update/" + id|
        pipe.put(path)

        let body: Data = self|
        pipe.put(body)

    }

}
