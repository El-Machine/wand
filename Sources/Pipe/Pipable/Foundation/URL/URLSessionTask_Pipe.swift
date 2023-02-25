//
//  NSURLSessionTask_Constructable.swift
//  Sandbox
//
//  Created by Alex Kozin on 24.08.2022.
//

import Foundation.NSURLSession

extension Pipe.Error {

    static func HTTP(_ reason: String) -> Error {
        Self(reason: reason)
    }

}

extension URLSessionDataTask: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let session: URLSession = pipe.get()
        let request: URLRequest = pipe.get()

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                pipe.put(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                pipe.put(Pipe.Error.HTTP("Not http?"))
                return
            }
            

            let statusCode = httpResponse.statusCode
            if !(200...299).contains(httpResponse.statusCode)  {
                pipe.put(Pipe.Error.HTTP("Code: \(statusCode)"))
                return
            }           

            let mime = httpResponse.mimeType
            if mime != "application/json" {
                pipe.put(Pipe.Error.HTTP("Mime: \(mime ?? "")"))
                return
            }

            guard let data = data else {
                pipe.put(Pipe.Error.HTTP("No data"))
                return
            }

            pipe.put(httpResponse)
            pipe.put(data)
        } as! Self

        return pipe.put(task)
    }

}
