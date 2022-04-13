//  Copyright © 2020-2022 Alex Kozin
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
//  IMPLIED, INCLUDING BUT NOT L IMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2022 Alex Kozin
//

import Foundation
import UIKit

final class Pipe {
    
//    private
    static var all = [String: Pipe]()

    static subscript(p: Any?) -> Pipe? {
        get {
            guard let p = p else {
                return nil
            }
            let key = String(describing: type(of: p))
            return all[key]
        }
        set {
            guard let p = p else {
                return
            }
            let key = String(describing: type(of: p))

            var all = self.all
            all[key] = newValue
            self.all = all
        }
    }
    
    lazy var piped: [String: Any] = {
        ["Any": self]
    }()

    static var defaultExpectations: [String: [Any]] = [
        "Error":
            [
                Event.every { (e: Error) in
                    print("Received error:\n\(e)\n")
                }
            ],
        Condition.Keys.all: [],
        Condition.Keys.any: []
    ]

    lazy var expectations =  [String: [Any]]()
    lazy var utils: [String: [Any]] = Pipe.defaultExpectations
    
    convenience init<T>(_ object: T) {
        self.init()

        Pipe[object as? Pipable] = self
        piped[String(describing: T.self)] = object
    }
    
    init() {
        print("#init\n\(self)")
    }
    
    func closeIfNeed(last: Any) {
        //TODO: CONCURENCYYYY!!!!

        //Clean empty expectations arrays
        self.expectations = self.expectations.filter {
            !$0.value.isEmpty
        }

        //Close Pipe if opnly utilitary expectations is live
        if self.expectations.isEmpty {
            close(last: last)
        }
        
    }

    func close(last: Any) {
        (utils[Condition.Keys.all] as? [Condition])?.forEach {
            _ = $0.handler(last)
        }

        piped.removeAll()
        expectations.removeAll()
        
        Pipe.all = Pipe.all.filter {
            $1 !== self
        }
    }
    
}

extension Pipe: Pipable {

    var isPiped: Pipe? {
        self
    }

}

extension Pipe: Producer {

    static func produce<T>(with: Any?, on pipe: Pipe, expecting: Event<T>) {
        //Sometimes we should just wait
    }

}

extension Pipe: CustomDebugStringConvertible {
    
    var debugDescription: String {
            """
            <Pipe \(String(describing: Unmanaged.passUnretained(self).toOpaque())) for
            \(expectations.keys)
            >
            """
    }
    
}

//Get
extension Pipe {
    
    func get<T>(or create: @autoclosure ()->(T)) -> T {
        get() ?? put(create())
    }
    
    func get<T>(for key: String? = nil) -> T? {
        piped[key ?? String(describing: T.self)] as? T
    }
    
}

//Expect
extension Pipe {

    @discardableResult
    func expect<T>(_ expectation: Event<T>,
                   with: Any? = nil,
                   producer: Producer.Type? = nil) -> Pipe {

        let producer = producer ?? T.self as! Producer.Type
        let key = producer.key(from: with as? Pipable) ?? T.self|

        //Request object first time
        let isFirst = add(expectation, key: key, to: &expectations)
        if isFirst {
            producer.produce(with: with, on: self, expecting: expectation)
        }


        return self
    }

    @discardableResult
    func addCondition(_ condition: Condition) -> Pipe {
        add(condition, key: condition.key, to: &utils)
        return self
    }

    @discardableResult
    private func add(_ event: Any, key: String, to: inout [String: [Any]]) -> Bool {
        let isFirst: Bool

        var stored = to[key, default: []]
        isFirst = stored.isEmpty
        stored.append(event)

        to[key] = stored

        return isFirst
    }
    
}

//Put
extension Pipe {

    @discardableResult
    func put<T>(_ object: T, key: String? = nil) -> T {
        let key = key ?? String(describing: T.self)
        Pipe[object as? Pipable] = self
        piped[key] = object

        //Make events happens
        expectations[key] = (expectations[key] as? [Event<T>])?.filter {
            $0.handler(object)
        }

        (utils[Condition.Keys.any] as? [Condition])?.forEach {
            _ = $0.handler(object)
        }

        closeIfNeed(last: object)

        return object
    }

}
