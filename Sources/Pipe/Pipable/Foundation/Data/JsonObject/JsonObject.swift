//
//  JsonObject.swift
//  Pipe
//
//  Created by Alex Kozin on 21.11.2022.
//

import Foundation


extension [Any]: JSONObject {

}

extension [String: Any]: JSONObject {

}

public protocol JSONObject {

    static func start<P, E>(expectating expectation: Expect<E>,
                                               with piped: P,
                                               on pipe: Pipe)

}

extension JSONObject {

    public static func start<P, E>(expectating expectation: Expect<E>,
                                               with piped: P,
                                               on pipe: Pipe) {

        guard pipe.start(expecting: expectation) else {
            return
        }

        let headers = ["Accept": "application/json",
                       "Content-Type": "application/json"]
        pipe.store(headers)

        pipe | .one { (data: Data) in
            do {
                let parsed = try JSONSerialization.jsonObject(with: data)
                pipe.put(parsed as! Self)
            } catch(let e) {
                pipe.put(e)
            }
        }

    }

}

@discardableResult
public func |<E: JSONObject, P> (piped: P, handler: @escaping (E)->() ) -> Pipe {
    piped | .one(handler)
}

@discardableResult
public func |<E: JSONObject> (pipe: Pipe?, handler: @escaping (E)->() ) -> Pipe {
    (pipe ?? Pipe()) as Any | .one(handler)
}

@discardableResult
public func |<E: JSONObject, P> (piped: P, expectation: Expect<E>) -> Pipe {
    let pipe = Pipe.attach(to: piped)
    E.start(expectating: expectation, with: piped, on: pipe)

    return pipe
}

//    static func |<T: JSONObject> (url: URL, handler: @escaping (T)->() ) -> Pipe {
//        var pipe: Pipe!
//        pipe = url | { (data: Data) in
//            do {
//                let parsed = try JSONSerialization.jsonObject(with: data)
//                handler(parsed as! T)
//            } catch(let e) {
//                pipe.put(e)
//            }
//        }
//
//        return pipe
//    }
//
//    static func | (url: URL, handler: @escaping (Data)->() ) -> Pipe {
//        let pipe = url.pipe
//
//        let session: URLSession = pipe.get()
//
//        pipe.put(["Accept": "application/json",
//                  "Content-Type": "application/json"])
//
//
//        let request: URLRequest = pipe.get()
//        print(request)
//        session.dataTask(with: request) { data, response, error in
//            if let data = data {
//                pipe.put(data)
//                pipe.put(response!)
//
//                handler(data)
//
//                return
//            }
//
//            if let e = error {
//                pipe.put(e)
//            }
//        }.resume()
//
//        return pipe
//    }


