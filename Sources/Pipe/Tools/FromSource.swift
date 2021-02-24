//
//  FromPipe.swift
//  Sample
//
//  Created by Alex Kozin on 18.01.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import Foundation

protocol FromSource: Pipable {

    associatedtype From: Source

    // Source object with options from Pipe
    // Uses pipable's or new Pipe
    //
    // let source = pipable | FromSource.self
    static func |(from: Pipable?, _: Self.Type) -> From

}

extension FromSource {

    static func |(from: Pipable?, _: Self.Type) -> From {
        from | From.self
    }

}

// Request FromSource object
// Uses new Pipe
//
// |{ (object: FromSource) in
//
// }
@discardableResult
prefix func |<T: FromSource> (handler: @escaping (T)->()) -> T.From {
    nil | handler
}

// Request FromSource object
// Uses pipable's or new Pipe
//
// pipable | { (object: FromSource) in
//
// }
@discardableResult
func |<T: FromSource> (pipable: Pipable?, handler: @escaping (T)->()) -> T.From {
    pipable | T.self | .every(handler)
}

