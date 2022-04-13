//
//  Conditions.swift
//  toolburator
//
//  Created by Alex Kozin on 09.04.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

enum Condition {

    typealias Handler = (Any)->()

    struct Keys {
        static var all = "all"
        static var any = "any"
    }

    case all((Any)->()), any((Any)->())

    var key: String {
        switch self {
            case .all(_):
                return Keys.all
            case .any(_):
                return Keys.any
        }
    }

    var handler: Handler {
        switch self {
            case .all(let h), .any(let h):
                return h
        }
    }

}

@discardableResult
func | (piped: Pipable, condition: Condition) -> Pipe {
    piped.pipe.addCondition(condition)
}

func |<H> (piped: Pipable, condition: Condition) -> H? {
    (piped | condition).get()
}


