//
//  Bundle_Pipe.swift
//  gym
//
//  Created by Alex Kozin on 28.02.2023.
//

import Foundation

extension Pipe {

    public typealias Resource = (name: String, type: String)

}

public
postfix func | (piped: Pipe.Resource) -> URL {
    Bundle.main.url(forResource: piped.name, withExtension: piped.type)!
}

public
postfix func | (piped: Pipe.Resource) -> String {
    Bundle.main.path(forResource: piped.name, ofType: piped.type)!
}
