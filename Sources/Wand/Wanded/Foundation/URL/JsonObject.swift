//
//  JsonObject.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation


extension Array: Asking {

    public static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        //Asking
        if let asking = Element.self as? Asking.Type {
            asking.wand(wand, asks: ask)

            return
        }

        guard Element.self == Any.self else {
            return
        }

        //Any
        guard wand.answer(the: ask) else {
            return
        }

        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        wand.save(headers)

//        wand | .one { (data: Data) in
//            do {
//                let parsed = try JSONSerialization.jsonObject(with: data)
//                pipe.put(parsed as! Self)
//            } catch(let e) {
//                pipe.put(e)
//            }
//        }

    }

}

extension Dictionary: Wanded where Key == String, Value == Any {

}

extension Dictionary: Asking where Key == String, Value == Any {

    public static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        guard wand.wand.answer(the: ask) else {
            return
        }

        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        wand.save(headers)

//        wand | .one { (data: Data) in
//            do {
//                let parsed = try JSONSerialization.jsonObject(with: data)
//                wand.add(parsed as! Self)
//            } catch(let e) {
//                wand.add(e)
//            }
//        }

    }

}

//extension Dictionary: JSONObject where Key == String, Value == Any {
//
//}
//
//
//public
//protocol JSONObject: Asking {
//
//
//}
//
//extension JSONObject {
//
//
//
//}
