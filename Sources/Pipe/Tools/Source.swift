//
//  FromSource.swift
//  Sample
//
//  Created by Alex Kozin on 07.12.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

protocol Source: Pipable {

    // Source object with options from Pipe
    // Uses pipable's or new Pipe
    //
    // let source = pipable | Source.self
    static func |(from: Pipable?, _: Self.Type) -> Self
    
}

// Source object from Pipe
// Uses pipable's or new Pipe
//
// let source = pipable|
postfix func |<T: Source> (from: Pipable?) -> T {
    from| ?? nil | T.self
}
