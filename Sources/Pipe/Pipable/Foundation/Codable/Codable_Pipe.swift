//
//  Codable_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 09.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

/**Pipable

 postfix |(data: Data) -> some PipeModel
 postfix |(raw: Dictionary) -> some PipeModel

 infix | (url: URL, reply: (some PipeModel)->() ) -> Pipe

 */

extension Data {

    static postfix func |<T: PipeModel>(data: Data) throws -> T {
        return try JSONDecoder().decode(T.self, from: data)
    }

}

extension Dictionary {

    static postfix func |(p: Self) -> Data {
        try! JSONSerialization.data(withJSONObject: p, options: [])
    }

    static postfix func |<T: PipeModel>(raw: Self) throws -> T {
        try JSONDecoder().decode(T.self, from: raw|)
    }

}

func |<T: PipeModel> (url: URL, handler: @escaping (T)->() ) -> Pipe {
    var pipe: Pipe!
    pipe = url | { (data: Data) in
        do {
            try handler(data|)
        } catch(let e) {
            pipe.put(e)
        }
    }

    return pipe
}
