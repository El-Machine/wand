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

/// Pipe
///
///
/// func get<T>() -> T
/// func get<T>(key: String) -> T
///
/// func put<T>(object: T) -> T
/// func put<T>(object: T, key: String) -> T
///
/// func start<E: Expectable>(expecting: Expect<E>) -> isFirst
/// func start<E: Expectable>(expecting: Expect<E>, key: String) -> isFirst
///
///
///
public final class Pipe {

    internal static var all = [String?: Pipe]()

    internal static subscript(piped: Any) -> Pipe? {
        get {
            if let key = key(piped) {
                return all[key]
            }

            return nil
        }
        set {
            if let pipe = newValue, let key = key(piped) {
                all[key] = pipe
            }
        }
    }

    internal static func key(_ piped: Any) -> String? {
        (piped as? Pipable)?.address
    }
    
    public private(set) lazy var piped: [String: Any] = ["Pipe": self]
    lazy var expectations = [String: [Expecting]]()

    public func close() {
        close(last: self)
    }

    func closeIfNeed(last: Any? = nil) {
        //TODO: CONCURENCYYYY!!!!

        //Try to close only if something expected before
        guard !expectations.isEmpty else {
            return
        }

        //Close Pipe if only inner expectations is live
        var expectingSomething = false
        root: for (_, list) in expectations {
            for expectation in list {
                if expectation.isInner == false {
                    expectingSomething = true

                    break root
                }
            }
        }

        if !expectingSomething {
            close(last: last ?? self)
        }

    }

    private func close(last: Any) {
        (expectations["All"] as? [Expect<Any>])?.forEach {
            _ = $0.handler(last)
        }

        piped.removeAll()
        expectations.removeAll()

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
    
}


//Get
extension Pipe {

    /// Get piped T or create and put to pipe
    /// - Parameters:
    ///   - key: Key to store
    ///   - create: Construction block
    /// - Returns: Instance of T
    public func get<T>(for key: String? = nil, or create: @autoclosure ()->(T)) -> T {
        get(for: key) ?? put(create(), key: key)
    }

    /// Get piped T for key
    /// - Parameter key: Key to store
    /// - Returns: Instance of T
    public func get<T>(for key: String? = nil) -> T? {
        piped[key ?? T.self|] as? T
    }

}

//Put
extension Pipe {

    @discardableResult
    public func put<T>(_ object: T, key: String? = nil) -> T {

        let key = key ?? T.self|
        Pipe[object] = self

        piped.updateValue(object, forKey: key)

        //Make events happens
        var inner = true

        let stored = expectations[key]
        expectations[key] = stored?.filter {
            if inner && !$0.isInner {
                inner = false
            }

            return $0.handle(object)
        }

        //Handle not inner expectations
        guard !inner else {
            return object
        }
        if stored?.isEmpty == false {
            (expectations[Any.self|] as? [Expect<Any>])?.forEach {
                _ = $0.handler(object)
            }
        }

        closeIfNeed(last: object)

        return object
    }

    public func putIf<T>(exist object: T?, key: String? = nil) {
        guard let object = object else {
            return
        }

        put(object, key: key)
    }

    public static func |(pipe: Pipe, array: Array<Any>) -> Pipe {
        pipe.store(array)
    }


    /// Store silently
    /// Without expectations check
    /// - Parameter array: objects to store
    /// - Returns: pipe
    @discardableResult
    public func store(_ array: Array<Any>) -> Pipe {
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

        return self
    }

}


//Expect
extension Pipe {

    public func start<E>(expecting expectation: Expect<E>,
                  key: String = E.self|) -> Bool {

        let stored = expectations[key]
        let isFirst = stored == nil
        expectations[key] = (stored ?? []) + [expectation]

        return isFirst
    }

}

extension Pipe: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

    public typealias ArrayLiteralElement = Any

    public typealias Key = String
    public typealias Value = Any

    convenience init<P>(object: P) {
        self.init()

        Pipe[object] = self
        piped[P.self|] = object
    }

    public convenience init(arrayLiteral elements: Any...) {
        self.init(array: elements)
    }

    public convenience init(array: [Any]) {
        self.init()

        store(array)
    }

    public convenience init(dictionaryLiteral elements: (String, Any)...) {
        self.init()

        elements.forEach { (key, object) in
            Pipe[object] = self
            piped[key] = object
        }
    }

    public convenience init(dictionary: [String: Any]) {
        self.init()

        dictionary.forEach { (key, object) in
            Pipe[object] = self
            piped[key] = object
        }
    }

    public static func attach<T>(to object: T) -> Pipe {

        if let pipable = object as? Pipable {
            return pipable.pipe
        }

        if let array = object as? [Any] {
            return Pipe(array: array)
        }

        if let dictionary = object as? [String: Any] {
            return Pipe(dictionary: dictionary)
        }

        return Pipe(object: object)
    }

}

extension Pipe: Pipable {

    public var pipe: Pipe {
        self
    }

    public var isPiped: Pipe? {
        self
    }

}

extension Pipe: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        "<Pipe \(address)>"
    }

    
    public var debugDescription: String {
            """
            \(description)
            expectations:
            \(expectations.keys)
            >
            """
    }
    
}
