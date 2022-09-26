//
//  NSURLSessionTask_Constructable.swift
//  Sandbox
//
//  Created by Alex Kozin on 24.08.2022.
//

import Foundation.NSURLSession

extension Pipe.Error {

    static func HTTP(_ reason: String) -> Error {
        Self(reason)
    }

}

extension URLSessionDataTask: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {

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
                pipe.put(Pipe.Error.HTTP("Wrong statusCode"))
                return
            }           

            guard let mime = httpResponse.mimeType, mime == "application/json" else {
                pipe.put(Pipe.Error.HTTP("Wrong mime"))
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
