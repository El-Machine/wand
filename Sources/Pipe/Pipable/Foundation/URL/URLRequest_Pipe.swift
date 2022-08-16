//
//  URLRequest_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 08.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

/**Pipable

 */

extension URLRequest: Constructor {

    static func | (piped: Any?, type: URLRequest.Type) -> URLRequest {
        let pipe = piped.pipe
        let environment = Pipe.Environment.current

        let url = piped as? URL ?? pipe.get() ?? {
            let path = piped as? String ?? pipe.get()!
            return (environment.APIBase + path)|
        }()

        let method = piped as? Pipe.Environment.Method ?? pipe.get() ?? .GET

        var request = URLRequest(url: url, timeoutInterval: method.timeout)

        let defaultHeaders = environment.headers
        request.allHTTPHeaderFields = (pipe.get() as [String : String]?)?
            .merging(defaultHeaders) { l, _ in
                l
            } ?? defaultHeaders

        request.httpMethod = method.rawValue
        request.httpBody = pipe.get()

        return request
    }


}

extension URLSession: Constructor {

    static func | (piped: Any?, type: URLSession.Type) -> Self {
        if let config = piped as? URLSessionConfiguration ?? piped.isPiped?.get() {
            return Self(configuration: config)
        } else {
            return URLSession.shared as! Self
        }
    }

}


extension URLSessionDataTask: Constructor {

    static func | (piped: Any?, type: URLSessionDataTask.Type) -> Self {
        let pipe = piped.pipe

        let session = piped as? URLSession ?? pipe.get()
        let request = piped as? URLRequest ?? pipe.get()

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                pipe.put(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else
            {
                pipe.put(Err.HTTP(data|))
                return
            }

            guard let mime = httpResponse.mimeType, mime == "application/json" else {
                //Handle
                return
            }

            guard let data = data else {
                //Handle
                return
            }

            pipe.put(response!)
            pipe.put(data)
        } as! Self

        return pipe.put(task)
    }

}
