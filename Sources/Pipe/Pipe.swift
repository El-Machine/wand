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

/// Pipe
///
///
/// func get<T>() -> T
/// func get<T>(key: String) -> T
///
/// func put<T>(object: T) -> T
/// func put<T>(object: T, key: String) -> T
///
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

    //Objects that inside pipe
    public private(set)
    lazy var scope: [String: Any] = ["Pipe": self]

    //Expectaions for objects that not yet in scope
    lazy var asking = [String: [AskFor]]()

    //Сlean all сaptured resources
    lazy var cleaners = [ ()->() ]()

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

    /// Get piped T for key
    public func get<T>(for key: String? = nil) -> T? {
        scope[key ?? T.self|] as? T
    }

    /// Get piped T for key
    public func extract<T>(for key: String? = nil) -> T? {
        scope.removeValue(forKey: key ?? T.self|) as? T
    }

}

//Put
extension Pipe {

    @discardableResult
    public func put<T>(_ object: T, key: String? = nil) -> T {

        let key = store(object, key: key)

        print("#put \(object)")

        //Find expectations for object
        guard let expectations = asking[key] else {
            return object
        }

        //Make events happens
        var onlyInner = true
        asking[key] = expectations.filter {
            if onlyInner && !$0.isInner {
                onlyInner = false
            }

            return ($0 as! Ask<T>).handler(object)
        }

        //Handle not inner expectations
        guard !onlyInner else {
            return object
        }

        //Handle .any
        if expectations.isEmpty == false {
            (asking[Any.self|] as? [Ask<Any>])?.forEach {
                _ = $0.handler(object)
            }
        }

        closeIfDone(last: object)

        return object
    }

    func notify() {

    }

    @discardableResult
    public func putIf<T>(exist object: T?, key: String? = nil) -> T? {
        guard let object = object else {
            return nil
        }

        return put(object, key: key)
    }

    @discardableResult
    public func store<T>(_ object: T, key: String? = nil) -> String {

        let result = key ?? T.self|
        Pipe[object] = self
        scope[result] = object

        return result
    }

    /// Store silently
    /// Without expectations check
    @discardableResult
    public func store(_ array: Array<Any>) -> Pipe {
        array.forEach { object in
            let key = type(of: object)|

            Pipe[object] = self
            scope[key] = object
        }

        return self
    }

}

//Ask
extension Pipe {

    public func ask<T>(for ask: Ask<T>,
                  key: String = T.self|) -> Bool {

        let stored = asking[key]
        let isFirst = stored == nil
        asking[key] = (stored ?? []) + [ask]

        //Call handler if object exist
        if let object: T = get() {

            let thread = Thread.current
            let queue = thread.isMainThread ? .main : thread.qualityOfService|

            queue.async {

                //Should remove?
                if ask.handler(object) == false {
                    self.asking[key] = (self.asking[key] as? [Ask<T>])?.filter {
                        $0 !== ask
                    }
                }

                self.closeIfDone(last: object)

            }

        }

        return isFirst
    }

}

public postfix func | (quality: QualityOfService) -> DispatchQueue {
    DispatchQueue.global(qos: quality|)
}

public postfix func | (piped: QualityOfService) -> DispatchQoS.QoSClass {

    switch piped {
        case .userInteractive:
            return .userInteractive

        case .userInitiated:
            return .userInitiated

        case .utility:
            return .utility

        case .background:
            return .background

        case .default:
            return .default

        @unknown default:
            fatalError()
    }

}



//Clean
extension Pipe {

    public func addCleaner(_ cleaner: @escaping ()->()) {
        cleaners.append(cleaner)
    }

}

//Close
extension Pipe {

    internal func closeIfDone(last: Any? = nil) {
        //TODO: ConcurrenY ?

        //Try to close only if something expected before
        guard !asking.isEmpty else {
            return
        }

        //Close Pipe if only inner asks is live
        var expectingSomething = false

        root: for (_, list) in asking {

            for ask in list {

                //Find first NOT inner
                if ask.isInner == false {

                    expectingSomething = true
                    break root

                }

            }

        }

        //Close Pipe if only inner asks is live
        if !expectingSomething {
            close(last: last ?? self)
        }

    }

    public func close() {
        close(last: self)
    }

    private func close(last: Any) {

        //Notify .all
        (asking["All"] as? [Ask<Any>])?.forEach {
            _ = $0.handler(last)
        }

        //Release all objects
        scope.removeAll()
        asking.removeAll()

        cleaners.forEach {
            $0()
        }

        //Release Pipe
        Pipe.all = Pipe.all.filter {
            $1 !== self
        }
    }

}

//Init with scope
extension Pipe: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

    public typealias ArrayLiteralElement = Any

    public typealias Key = String
    public typealias Value = Any

    convenience init<T>(object: T) {
        self.init()

        Pipe[object] = self
        scope[T.self|] = object
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
            scope[key] = object
        }
    }

    public convenience init(dictionary: [String: Any]) {
        self.init()

        dictionary.forEach { (key, object) in
            Pipe[object] = self
            scope[key] = object
        }
    }

    public static func attach<S>(to scope: S?) -> Pipe {

        guard let scope else {
            return Pipe()
        }

        if let pipable = scope as? Pipable {
            return pipable.pipe
        }

        if let array = scope as? [Any] {
            return Pipe(array: array)
        }

        if let dictionary = scope as? [String: Any] {
            return Pipe(dictionary: dictionary)
        }

        return Pipe(object: scope)
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

            asking:
            \(asking.keys)
            >

            """
    }
    
}
