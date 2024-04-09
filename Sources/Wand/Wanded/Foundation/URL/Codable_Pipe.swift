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

    public
    static postfix func |<T: Decodable>(data: Data) throws -> T {
        try JSONDecoder().decode(T.self, from: data)
    }

    static public postfix func |(raw: Self) throws -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: raw, options: []) as? [String : Any]
    }

    static public postfix func |(raw: Self) throws -> [Any]? {
        try? JSONSerialization.jsonObject(with: raw, options: []) as? [Any]
    }

}

extension Dictionary {

    static public postfix func |(p: Self) -> Data {
        try! JSONSerialization.data(withJSONObject: p, options: [])
    }

}

//public postfix func |<T: Rest.Model>(raw: [String: Any]?) throws -> T {
//    try (raw!)|
//}

public postfix func |<T: Model>(raw: [String: Any]) throws -> T {
    try JSONDecoder().decode(T.self, from: raw|)
}

extension Array {

    static public postfix func |(p: Self) -> Data {
        try! JSONSerialization.data(withJSONObject: p, options: [])
    }

    static public postfix func |<T: Model>(raw: Self) throws -> [T] {
        try JSONDecoder().decode([T].self, from: raw|)
    }

}

public
postfix func |(resource: Pipe.Resource) throws -> Data {
    try Data(contentsOf: resource|)
}

public
postfix func |<T: Decodable> (resource: Pipe.Resource) throws -> T {
    let data: Data = try Data(contentsOf: resource|)
    return try data|
}

public
postfix func |(resource: Pipe.Resource) throws -> [String: Any]? {
    let data: Data = try Data(contentsOf: resource|)
    return try data|
}
