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
import UIKit

public
protocol Rest_Model: Model, Asking, Codable {

    static var base: String? {get}
    static var path: String {get}

    static var headers: [String : String]? {get}

}

public
extension Ask {

    class Get: Ask {
    }

    class Post: Ask {
    }

    class Put: Ask {
    }

    class Delete: Ask {
    }

}

public
extension Ask {

    static func get(handler: @escaping (T)->() ) -> Get {
        .one(handler: handler)
    }

    static func post(handler: @escaping (T)->() ) -> Post {
        Post.one(handler: handler)
    }

    static func put(handler: @escaping (T)->() ) -> Put {
        Put.one(handler: handler)
    }

    static func delete(handler: @escaping (T)->() ) -> Delete {
        Delete.one(handler: handler)
    }

}

public
extension Ask where T == Array<Any> {

    static func get(handler: @escaping (T)->() ) -> Get {
        .one(handler: handler)
    }

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

        if
            let headers,
            !pipe.exist(type: [String : String].self)
        {
            pipe.store(headers)
        }
        
        pipe | .one { (data: Data) in

            do {

                if
                    let method: Rest.Method = pipe.get(),
                    method != .GET,
                    let object: Self = pipe.get()
                {
                    pipe.put(object)
                } else {

                    let D = T.self as! Decodable.Type
                    
                    let parsed = try JSONDecoder().decode(D.self, from: data)

                    pipe.put(parsed as! T)
                }
            } catch(let e) {
                pipe.put(e)
            }

            pipe.close()
        }
        
    }
    
}
