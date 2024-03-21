//
//  RawRepresentable_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 15.11.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

extension RawRepresentable {

    @inlinable
    static postfix func |(piped: Self) -> RawValue {
        piped.rawValue
    }

}

@inlinable
postfix func |<T: RawRepresentable>(piped: T.RawValue?) -> T? {
    (piped!)|
}

@inlinable
postfix func |<T: RawRepresentable>(piped: T.RawValue?) -> T {
    ((piped!)|)!
}

@inlinable
postfix func |<T: RawRepresentable>(piped: T.RawValue) -> T? {
    T.init(rawValue: piped)
}
