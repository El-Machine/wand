//
//  String.Encoding_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 26.09.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

public func |(p: Data, encoding: String.Encoding) -> String {
    String(data: p, encoding: encoding)!
}

public func |(p: Data?, encoding: String.Encoding) -> String {
    guard let piped = p else {
        return ""
    }
    return String(data: piped, encoding: encoding)!
}

public func |(p: Data?, encoding: String.Encoding) -> String? {
    guard let piped = p else {
        return nil
    }
    return String(data: piped, encoding: encoding)
}
