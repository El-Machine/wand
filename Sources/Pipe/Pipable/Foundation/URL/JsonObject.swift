//
//  JsonObject.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation


extension Array: Asking {

    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {

        if let asking = Element.self as? Asking.Type {
            asking.ask(ask, from: pipe)
        }

    }

}

extension Array: JSONObject where Element == Any {

}

extension Dictionary: Asking where Key == String, Value == Any {

}

extension Dictionary: JSONObject where Key == String, Value == Any {

}


public protocol JSONObject: Asking {


}

extension JSONObject {

    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) {

        guard pipe.ask(for: ask) else {
            return
        }

        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        pipe.store(headers)

//        pipe | .one { (data: Data) in
//            do {
//                let parsed = try JSONSerialization.jsonObject(with: data)
//                pipe.put(parsed as! Self)
//            } catch(let e) {
//                pipe.put(e)
//            }
//        }

    }

}
