//  Copyright © 2020-2022 El Machine 🤖
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//

import Foundation

public protocol Rest_Model: AskingWithout, Codable {


    static var base: String? {get}
    static var path: String {get}

    static var headers: [String : String]? {get}

}

public
extension Ask where T: Rest.Model {

    static func get(handler: @escaping (T)->() ) -> Self {
        let ask = Self.one(handler: handler)
        ask.onAttach = { pipe in

            let path = T.base ?? "" + T.path
            pipe.store(path)

        }

        return ask
    }

    static func post(handler: @escaping (T)->() ) -> Self {
        let ask = Self.one(handler: handler)
        ask.onAttach = { pipe in

            let path = T.base ?? "" + T.path
            pipe.store(path)

            pipe.store(Rest.Method.POST)

        }

        return ask
    }

    static func put(handler: @escaping (T)->() ) -> Self {
        .one(handler: handler)
    }

//    func post<P>(with piped: P, on pipe: Pipe) {
//        pipe.put(URLRequest.Method.POST)
//    }
//
//    func put<P>(with piped: P, on pipe: Pipe) {
//        pipe.put(URLRequest.Method.PUT)
//    }

}

public
extension Rest_Model {
    
    static var path: String? {
        nil
    }
    
    static var headers: [String : String]? {
        nil
    }
    
    static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {
        
        guard pipe.ask(for: ask) else {
            return
        }
        
        pipe | .one { (data: Data) in
            
            do {
                if let object: Self = pipe.get() {
                    pipe.put(object)
                } else {
                    let parsed: Self = try data|
                    pipe.put(parsed)
                }
            } catch(let e) {
                pipe.put(e)
            }
            
            pipe.close()
        }
        
    }
    
}
