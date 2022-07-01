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

final class Pipe {

    internal static var all = [String: Pipe]()
    internal static subscript<P>(p: P) -> Pipe? {
        get {
            all[type(of: p)|]
        }
        set {
            if let pipe = newValue {
                all.updateValue(pipe, forKey: type(of: p)|)
            }
        }
    }
    
    lazy var piped: [String: Any] = ["Pipe": self]

    func close() {
        close(last: self)
    }

    private func closeIfNeed(last: Any) {
        //TODO: CONCURENCYYYY!!!!

        //Try to close only if something expected before
        guard !expectations.isEmpty else {
            return
        }

        //Close Pipe if only inner expectations is live
        var expectingSomething = false
        root: for (_, list) in expectations {
            for expectation in list {
                if (expectation as? Expecting)?.inner == false {
                    expectingSomething = true

                    break root
                }
            }
        }

        if !expectingSomething {
            close(last: last)
        }

    }
    private func close(last: Any) {
        (expectations["All"] as? [Expect<Any>])?.forEach {
            _ = $0.handler(last)
        }

        piped.removeAll()

        Pipe.all = Pipe.all.filter {
            $1 !== self
        }
    }


//    #if TESTING

    init() {
        print("|💪🏽 #init\n\(self)")
    }


    deinit {
        print("|✅ #bonsua\n\(self)\n")
    }

//    #endif
    
}

extension Pipe: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

    typealias ArrayLiteralElement = Any

    typealias Key = String
    typealias Value = Any

    convenience init(arrayLiteral elements: Any...) {
        self.init(elements)
    }

    convenience init(dictionaryLiteral elements: (String, Any)...) {
        self.init()

        elements.forEach { (key, object) in
            Pipe[object] = self
            piped[key] = object
        }
    }

    convenience init<P>(_ object: P?) {
        self.init()

        guard let object = object else {
            return
        }

        Pipe[object] = self
        piped[P.self|] = object
    }

    convenience init(_ array: [Any]) {
        self.init()

        array.forEach {
            let key: String
            let object: Any

            if let keyValue = $0 as? (key: String, value: Any) {
                object = keyValue.value
                key = keyValue.key
            } else {
                object = $0
                key = type(of: object)|
            }

            Pipe[object] = self
            piped[key] = object
        }
    }

}

extension Pipe: Pipable {

    var isPiped: Pipe? {
        self
    }

}

extension Pipe: Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
    }

}

extension Pipe: CustomDebugStringConvertible {
    
    var debugDescription: String {
            """
            <Pipe \(Unmanaged.passUnretained(self).toOpaque()|)> for
            \(expectations.keys)
            >
            """
    }
    
}

//Get
extension Pipe {
    
    func get<E>(or create: @autoclosure ()->(E)) -> E {
        get() ?? put(create())
    }
    
    func get<E>(for key: String? = nil) -> E? {
        piped[key ?? E.self|] as? E
    }

    static postfix func |<E>(pipe: Pipe) -> E? {
        pipe.get()
    }
    
}

//Put
extension Pipe {

    @discardableResult
    func put<E>(_ object: E, key: String? = nil) -> E {
        let key = key ?? E.self|
        Pipe[object] = self

        piped.updateValue(object, forKey: key)

        //Make events happens
        var inner = true
        expectations[key] = (expectations[key] as? [Expect<E>])?.filter {
            if inner && !$0.inner {
                inner = false
            }

            return $0.handler(object)
        }

        //Handle not inner expectations
        guard !inner else {
            return object
        }

        (expectations[Any.self|] as? [Expect<Any>])?.forEach {
            _ = $0.handler(object)
        }

        closeIfNeed(last: object)

        return object
    }

}
