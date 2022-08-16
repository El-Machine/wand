//
//  Model.swift
//  Energy
//
//  Created by Alex Kozin on 09.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

//Asking

protocol PipeModel: Pipable, Codable {

    static postfix func |(piped: Self.Type) -> URLSessionDataTask

}

extension PipeModel {

    static func |(piped: Self.Type, handler: @escaping ((Data)->()) ) -> Pipe {

        let task: URLSessionDataTask = piped|
        task | handler

        task.resume()
        return task.pipe
    }

}
