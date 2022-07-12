//
//  URL_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 11.07.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

//URL
postfix func |(piped: String?) -> URL {
    URL(string: piped!)!
}

postfix func |(piped: String) -> URL {
    URL(string: piped)!
}

postfix func |(piped: URL) -> String {
    piped.absoluteString
}

postfix func |(piped: URL?) -> String? {
    piped?.absoluteString
}

extension URLSession: Constructor {

    static func | (piped: Any?, type: URLSession.Type) -> Self {
        if let config: URLSessionConfiguration = piped.isPiped?.get() {
            return Self(configuration: config)
        } else {
            return URLSession.shared as! Self
        }
    }

}
