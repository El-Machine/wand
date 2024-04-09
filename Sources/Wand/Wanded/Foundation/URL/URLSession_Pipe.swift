//
//  URLSession_Pipe.swift
//  Sandbox
//
//  Created by Alex Kozin on 24.08.2022.
//

import Foundation.NSURLSession

extension URLSession: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let session: Self

        if let config: URLSessionConfiguration = pipe.get() {
            session = Self(configuration: config)
        } else {
            session = Self.shared as! Self
        }

        return pipe.put(session)
    }

}
