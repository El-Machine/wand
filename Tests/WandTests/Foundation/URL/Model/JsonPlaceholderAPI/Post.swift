//
//  Employee.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation

public
extension JSONplaceholderAPI {

    struct Post: Codable {

        let id: Int

        let userId: Int
        let title: String?
        let body: String?

    }

}
