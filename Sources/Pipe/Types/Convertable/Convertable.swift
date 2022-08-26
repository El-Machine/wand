//
//  Convertable.swift
//  Sandbox
//
//  Created by Alex Kozin on 22.08.2022.
//

import Foundation

/// Convert object to another type.
public protocol Convertable: Pipable {

    static func convert<P>(_ piped: P) -> Self

}

public postfix func |<P, T: Convertable>(piped: P?) -> T {
    fatalError("📲 implement with Self")
}
