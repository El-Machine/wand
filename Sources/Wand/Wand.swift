//  Copyright © 2020-2024 El Machine 🤖
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

public 
final
class Wand {

    internal 
    static var all = [Int: Wand]()

    internal 
    static subscript<T>(_ object: T) -> Wand? {
        get {

            if T.self is AnyClass {
                let key = unsafeBitCast(object, to: Int.self)
                return all[key]
            }

            return nil

        }
        set {

            if let pipe = newValue, T.self is AnyClass {
                let key = unsafeBitCast(object, to: Int.self)
                all[key] = pipe
            }

        }
    }

    public 
    private(set)
    var context = [String: Any]()

    public 
    private(set)
    var asking = [String: [AskFor]]()

//    #if TESTING
    
        init() {
            print("|💪🏽 #init\n\(self) ask \(asking)")
        }


        deinit {
            print("|✅ #bonsua\n\(self)\n")
        }

//    #endif

}
 

//internal static subscript<T>(piped: T) -> Pipe? {
//    get {
//        return all[address(for: piped)]
//    }
//    set {
//        if let pipe = newValue {
//            all[address(for: piped)] = pipe
//        }
//    }
//}
//
//static func address<T: AnyObject>(for model: T) -> String {
//    "\(Unmanaged.passUnretained(model).toOpaque())"
//}
//
//static func address<T>(for model: T) -> String {
//    var address: String?
//    var mutable = model
//    withUnsafePointer(to: &mutable) { pointer in
//        address = String(format: "%p", pointer)
//    }
//
//    return address!
//}

//Get
//From context
public
extension Wand {

    func get<T>(for key: String? = nil) -> T? {
        context[key ?? T.self|] as? T
    }

    func get<T>(for key: String? = nil, or create: @autoclosure ()->(T)) -> T {
        get(for: key) ?? {
            let object = create()
            save(object, key: key)

            return object
        }()
    }

}

//Add
//Triggering Askings
public
extension Wand {

    @discardableResult
    func add<T>(_ object: T, for key: String? = nil) -> T {

        //Save to context
        let key = save(object, key: key)

        //Somebody asking for?
        guard let expectations = asking[key] as? [Ask<T>] else {
            return object
        }

        //Make events happens
        var onlyInner = true
        asking[key] = expectations.filter {
            if onlyInner && !$0.isInner {
                onlyInner = false
            }

            return $0.handle(object)
        }

        //Handle not inner expectations
        guard !onlyInner else {
            return object
        }

        //Handle .any
        if expectations.isEmpty == false {
            (asking[Any.self|] as? [Ask<Any>])?.forEach {
                _ = $0.handle(object)
            }
        }

        closeIfDone(last: object)

        return object
    }

    @discardableResult
    func addIf<T>(exist object: T?, for key: String? = nil) -> T? {
        guard let object = object else {
            return nil
        }

        return add(object, for: key)
    }

}

//Save
//Without triggering Askings
public
extension Wand {

    @discardableResult
    func save<T>(_ object: T, key: String? = nil) -> String {

        let result = key ?? T.self|
        Wand[object] = self
        context[result] = object

        return result
    }

    @discardableResult
    func save(sequence: any Sequence) -> Self {
        sequence.forEach { object in
            let key = type(of: object)|

            Wand[object] = self
            context[key] = object
        }

        return self
    }

}

//Ask
//For objects
public
extension Wand {


    func ask<T>(for ask: Ask<T>,
                       checkScope: Bool = false) -> Bool {

        let key = ask.key ?? T.self|

        let stored = asking[key]
        let isFirst = stored == nil
        asking[key] = (stored ?? []) + [ask]


        //Call handler if object exist
        if checkScope, let object: T = get() {

            let thread = Thread.current
            let queue: DispatchQueue = thread.isMainThread ? .main : thread.qualityOfService|

            queue.async {

                //Should remove?
                //Optimize
                if ask.handle(object) == false {
                    self.asking[key] = (self.asking[key] as? [Ask<T>])?.filter {
                        $0 !== ask
                    }
                }

                //Optimize
                self.closeIfDone(last: object)

            }

        }

        return isFirst
    }

}

//Close
extension Wand {

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
            _ = $0.handle(last)
        }

        //Release all objects
        context.removeAll()
        asking.removeAll()

//        cleaners.forEach {
//            $0()
//        }
//
//        cleaners.removeAll()

        //Release Pipe
        Wand.all = Wand.all.filter {
            $0.value !== self
        }

    }

}

//Init with scope
extension Wand: ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

    public typealias ArrayLiteralElement = Any

    public typealias Key = String
    public typealias Value = Any

    convenience init<T>(for object: T) {
        self.init()

        Wand[object] = self
        context[T.self|] = object
    }

    public convenience init(arrayLiteral elements: Any...) {
        self.init(array: elements)
    }

    public convenience init(array: [Any]) {
        self.init()

        save(sequence: array)
    }

    public convenience init(dictionaryLiteral elements: (String, Any)...) {
        self.init()

        elements.forEach { (key, object) in
            Wand[object] = self
            context[key] = object
        }
    }

    public convenience init(dictionary: [String: Any]) {
        self.init()

        dictionary.forEach { (key, object) in
            Wand[object] = self
            context[key] = object
        }
    }

    public static func attach<S>(to context: S? = nil) -> Wand {

        guard let context else {
            return Wand()
        }

        if let wanded = context as? Wanded {
            return wanded.wand
        }

        if let array = context as? [Any] {
            return Wand(array: array)
        }

        if let dictionary = context as? [String: Any] {
            return Wand(dictionary: dictionary)
        }

        return Wand(for: context)
    }

}

extension Wand: Wanded {

    public var pipe: Wand {
        self
    }

    public var isPiped: Wand? {
        self
    }

}

extension Wand: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        "| Wand \(String(format: "%p", address))"
    }

    
    public var debugDescription: String {
            """

            \(description)

            asking:
            \(asking.keys)

            """
    }
    
}
