//
//  URLSession_Pipe.swift
//  Sandbox
//
//  Created by Alex Kozin on 24.08.2022.
//

import Foundation.NSURLSession

extension URLSession: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {
        if let config = piped as? URLSessionConfiguration ?? pipe.get() {
            return Self(configuration: config)
        } else {
            return URLSession.shared as! Self
        }
    }

}
