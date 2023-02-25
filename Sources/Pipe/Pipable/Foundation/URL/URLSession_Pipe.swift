//
//  URLSession_Pipe.swift
//  Sandbox
//
//  Created by Alex Kozin on 24.08.2022.
//

import Foundation.NSURLSession

extension URLSession: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        if let config: URLSessionConfiguration = pipe.get() {
            return Self(configuration: config)
        } else {
            return Self.shared as! Self
        }
    }

}
