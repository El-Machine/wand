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

public protocol RestModel: ExpectableLabeled, ExpectableWithout, Codable where Label == URLRequest.Method {

    static var path: String? {get}
    static var headers: [String : String]? {get}

    static func get(on pipe: Pipe)

    func post(on pipe: Pipe)
    func put(on pipe: Pipe)

}

extension RestModel {

    static var path: String? {
        nil
    }

    static var headers: [String : String]? {
        nil
    }

    static func get(on pipe: Pipe) {
        ShoudBeOverriden()
    }

    func post(on pipe: Pipe) {
        ShoudBeOverriden()
    }

    func put(on pipe: Pipe) {
        ShoudBeOverriden()
    }

    //TODO?: start<P: URLSessionDataTask, E: RestModel>
    static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {

        _ = pipe.start(expecting: expectation)

        pipe.putIf(exist: expectation.with as? URLRequest.Method)

        if let task = piped as? URLSessionDataTask {
            start(expectating: expectation as! Expect<Self>,
                  task: task,
                  on: pipe)

            return
        }

        //Add default path
        pipe.putIf(exist: path)

        //Add default headers
        pipe.putIf(exist: headers)

        switch expectation.with as? Label {
            case .none, .GET:
                get(on: pipe)

            case .POST:
                (piped as! Self).post(on: pipe)
                //            case .HEAD:
                //                <#code#>
            case .PUT:
                (piped as! Self).put(on: pipe)
                //            case .PATCH:
                //                <#code#>
                //            case .DELETE:
                //                <#code#>

            default:
                break
        }

    }

    static func start(expectating expectation: Expect<Self>,
                      task: URLSessionDataTask,
                      on pipe: Pipe) {

        task | { (data: Data) in

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

func ShoudBeOverriden(function: String = #function) -> Never {
    fatalError("\(function) should be overriden.")
}
//
//func |<E: RestModel> (url: URL, handler: @escaping (E)->() ) -> Pipe {
//    var pipe: Pipe!
//    pipe = url | { (data: Data) in
//        do {
//            try handler(data|)
//        } catch(let e) {
//            pipe.put(e)
//        }
//    }
//
//    return pipe
//}

extension Expect where T: RestModel {

    static func get(handler: @escaping (T)->()) -> Self {
        Expect.one(.GET, handler) as! Self
    }

    static func post(handler: @escaping (T)->()) -> Self {
        Expect.one(.POST, handler) as! Self
    }

    static func head(handler: @escaping (T)->()) -> Self {
        Expect.one(.HEAD, handler) as! Self
    }

    static func put(handler: @escaping (T)->()) -> Self {
        Expect.one(.PUT, handler) as! Self
    }

    static func patch(handler: @escaping (T)->()) -> Self {
        Expect.one(.PATCH, handler) as! Self
    }

}
