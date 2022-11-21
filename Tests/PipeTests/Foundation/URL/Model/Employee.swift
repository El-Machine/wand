//
//  Employee.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Pipe

struct Employee: DummyRestAPIModel {

    var id: Int?

    var age: Int?
    var name: String?
    var salary: Int?

    static var path: String? {
        basePath + "/employees"
    }

}
