//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

public extension URLRequest {

    enum Method: String {
        case GET
        case POST
        case HEAD
        case PUT
        case PATCH
        case DELETE

        var timeout: TimeInterval {
            switch self {
                case .POST, .PUT, .PATCH:
                    return 30
                default:
                    return 15
            }
        }
    }

}

extension URLRequest: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> URLRequest {

        let url = piped as? URL ?? pipe.get() ?? {
            let path = piped as? String ?? pipe.get()!
            return path|
        }()

        let method = piped as? Method ?? pipe.get() ?? .GET
        let timeout = piped as? TimeInterval ?? pipe.get() ?? method.timeout

        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.allHTTPHeaderFields = pipe.get()
        request.httpMethod = method.rawValue
        request.httpBody = pipe.get()

        return request
    }

}
