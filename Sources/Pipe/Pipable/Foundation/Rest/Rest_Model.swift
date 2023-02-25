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

public protocol Rest_Model: ExpectableLabeled, Codable {

    static var headers: [String : String]? {get}

    @inline(__always)
    static func get<P, E>(_ expectation: Expect<E>, with piped: P, on pipe: Pipe)

    func post<P>(with piped: P, on pipe: Pipe)
    func put<P>(with piped: P, on pipe: Pipe)

}

public extension Rest_Model {

    static var headers: [String : String]? {
        nil
    }

    @inline(__always)
    static func get<P, E>(_ expectation: Expect<E>, with piped: P, on pipe: Pipe) {
        
    }

    func post<P>(with piped: P, on pipe: Pipe) {
        pipe.put(URLRequest.Method.POST)
    }

    func put<P>(with piped: P, on pipe: Pipe) {
        pipe.put(URLRequest.Method.PUT)
    }

    //TODO?: start<P: URLSessionDataTask, E: RestModel>
    static func start<P, E: Expectable>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {

        _ = pipe.start(expecting: expectation)

        if let task = piped as? URLSessionDataTask {
            start(expectating: expectation as! Expect<Self>,
                  task: task,
                  on: pipe)

            return
        }

        //1) Look for URL
        if pipe.putIf(exist: piped as? URL) == nil {

            //2) Look for path
            pipe.putIf(exist: piped as? String)

        }

        //Add default headers
        // - implemented in self?
        pipe.putIf(exist: headers)

        switch expectation.with as? String {
            case .none, Expect<Self>.get().key:
                get(expectation, with: piped, on: pipe)

            case Expect<Self>.post().key:

                pipe.store(piped)
                pipe.store(URLRequest.Method.POST)
                (piped as! Self).post(with: piped, on: pipe)

            case Expect<Self>.put().key:

                pipe.store(piped)
                pipe.store(URLRequest.Method.PUT)
                (piped as! Self).put(with: piped, on: pipe)

                //            case .HEAD:
                //                <#code#>

                //            case .PATCH:
                //                <#code#>w
                //            case .DELETE:
                //                <#code#>

            default:
                break
        }

        let task: URLSessionDataTask = pipe.get()

        start(expectating: expectation as! Expect<Self>,
              task: task,
              on: pipe)
    }

    static func requestData(from pipe: Pipe) {

        let task: URLSessionDataTask = pipe.get()
        task | self.one
    }

    static func start(expectating expectation: Expect<Self>,
                      task: URLSessionDataTask,
                      on pipe: Pipe) {

        task | .one { (data: Data) in

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

public extension Expect where T: Rest.Model {

    static func get(_ handler: ( (T)->() )? = nil) -> Self {
        .oneLabeled(handler)
    }

    static func post(_ handler: ( (T)->() )? = nil) -> Self {
        .oneLabeled(handler)
    }

    static func head(_ handler: ( (T)->() )? = nil) -> Self {
        .oneLabeled(handler)
    }

    static func put(_ handler: ( (T)->() )? = nil) -> Self {
        .oneLabeled(handler)
    }

    static func patch(_ handler: ( (T)->() )? = nil) -> Self {
        .oneLabeled(handler)
    }

}
