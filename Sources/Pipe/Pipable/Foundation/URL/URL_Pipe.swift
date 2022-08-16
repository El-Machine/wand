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

/** Pipable
 URL

 postfix func |(piped: String) -> URL
 postfix func |(piped: String?) -> URL
 postfix func |(piped: String?) -> URL?

 postfix func |(piped: URL) -> String
 postfix func |(piped: URL?) -> String?

 infix | (url: URL, reply: ([String: Any])->() ) -> Pipe
 infix | (url: URL, reply: ([Any])->() ) -> Pipe

 infix | (url: URL, reply: (Data)->() ) -> Pipe


 */

postfix func |(piped: String) -> URL {
    URL(string: piped)!
}

postfix func |(piped: String?) -> URL {
    URL(string: piped!)!
}

postfix func |(piped: String?) -> URL? {
    guard let piped = piped else {
        return nil
    }

    return URL(string: piped)
}

postfix func |(piped: URL) -> String {
    piped.absoluteString
}

postfix func |(piped: URL?) -> String? {
    piped?.absoluteString
}

extension URL: Pipable {

    static func |<T: JSONObject> (url: URL, handler: @escaping (T)->() ) -> Pipe {
        var pipe: Pipe!
        pipe = url | { (data: Data) in
            do {
                let parsed = try JSONSerialization.jsonObject(with: data)
                handler(parsed as! T)
            } catch(let e) {
                pipe.put(e)
            }
        }

        return pipe
    }

    static func | (url: URL, handler: @escaping (Data)->() ) -> Pipe {
        let pipe = url.pipe


//        let session: URLSession = pipe.get()
//        let request: URLRequest = url|
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

        return pipe
    }

}

protocol JSONObject {

}

extension Array: JSONObject {

}

extension Dictionary: JSONObject {

}
