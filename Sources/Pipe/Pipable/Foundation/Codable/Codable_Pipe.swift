//
//  Codable_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 09.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

/**Pipable

 postfix |(data: Data) -> some RestModel
 postfix |(raw: Dictionary) -> some RestModel

 infix | (url: URL, reply: (some RestModel)->() ) -> Pipe

 */

extension Data {

    static public postfix func |<T: RestModel>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

}

extension Dictionary {

    static public postfix func |(p: Self) -> Data {
        try! JSONSerialization.data(withJSONObject: p, options: [])
    }

    static public postfix func |<T: RestModel>(raw: Self) throws -> T {
        try JSONDecoder().decode(T.self, from: raw|)
    }

}
