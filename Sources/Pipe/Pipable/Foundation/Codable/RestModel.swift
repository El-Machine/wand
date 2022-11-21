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

public protocol RestModel: ExpectableLabeled, ExpectableWithout, Codable {

    static var path: String? {get}
    static var headers: [String : String]? {get}

    static func get(on pipe: Pipe)

    func post(on pipe: Pipe)
    func put(on pipe: Pipe)

}

public extension RestModel {

    static var path: String? {
        nil
    }

    static var headers: [String : String]? {
        nil
    }

    static func get(on pipe: Pipe) {
        let task: URLSessionDataTask = pipe.get()
        task | self.every
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

        switch expectation.with as? String {
            case .none, Expect<Self>.get().key:
                get(on: pipe)

            case Expect<Self>.post().key:

                pipe.put(URLRequest.Method.POST)
                (piped as! Self).post(on: pipe)

            case Expect<Self>.put().key:

                pipe.put(URLRequest.Method.PUT)
                (piped as! Self).put(on: pipe)

                //            case .HEAD:
                //                <#code#>

                //            case .PATCH:
                //                <#code#>w
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

extension Expect where T: RestModel {

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

//    static func oneLabeled(label: String = #function, _ handler: ( (T)->() )? = nil) -> Self {
//        Expect.one(label, handler) as! Self
//    }

}

@discardableResult
public func |<E: RestModel, P> (piped: P, handler: @escaping ([E])->() ) -> Pipe {
    piped | .one(handler)
}

@discardableResult
public func |<E: RestModel> (pipe: Pipe?, handler: @escaping ([E])->() ) -> Pipe {
    (pipe ?? Pipe()) as Any | .one(handler)
}

@discardableResult
public func |<E: RestModel, P> (piped: P, expectation: Expect<[E]>) -> Pipe {
    let pipe = Pipe.attach(to: piped)
    E.start(expectating: expectation, with: piped, on: pipe)

    return pipe
}
