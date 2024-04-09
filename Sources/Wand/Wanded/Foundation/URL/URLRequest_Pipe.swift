//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

extension URLRequest: Constructable {

    public static func construct(in pipe: Pipe) -> URLRequest {

        let url: URL = pipe.get() ?? {
            let path: String = pipe.get()!
            return path|
        }()

        let method: Rest.Method     = pipe.get() ?? .GET
        let timeout: TimeInterval   = pipe.get() ?? method.timeout

        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.allHTTPHeaderFields = pipe.get()
        request.httpMethod = method.rawValue
        request.httpBody = pipe.get()

        return request
    }

}
