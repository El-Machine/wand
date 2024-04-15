/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

import Foundation

public 
final
class Wand {

    //All Wands
    internal
    struct Weak {
        weak var item: Wand?
    }

    internal
    static var all = [Int: Wand.Weak]()

    internal
    static subscript<T>(_ object: T) -> Wand? {
        get {

            if T.self is AnyClass {
                let key = unsafeBitCast(object, to: Int.self)
                return all[key]?.item
            }

            return nil

        }
        set {

            if let wand = newValue, T.self is AnyClass {
                let key = unsafeBitCast(object, to: Int.self)
                all[key] = Weak(item: wand)
            }

        }
    }

    public
    internal(set)
    var context = [String: Any]()

    public
    internal(set)
    var asking = [String: (last: Any, cleaner: ( ()->() )? )]()

    init() {
        log("|💪🏽 #init\n\(self)\n")
    }

    public
    convenience init<T>(for object: T) {
        self.init()

        Wand[object] = self
        context[T.self|] = object
    }

    deinit {
        close()
        log("|✅ #bonsua\n\(self)\n")
    }

}

/// Attach
extension Wand {

    public
    static func attach<C>(to context: C? = nil) -> Wand {

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

/// Get
/// From context
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

/// Add
/// Triggering Asking
public
extension Wand {

    @discardableResult
    func add<T>(_ object: T, for raw: String? = nil) -> T {

        let key = save(object, key: raw)

        //Answer stored questions
        guard
            let stored = asking[key]
        else {
            return object
        }

        //Start from Head
        if let tail = (stored.last as? Ask<T>)?.head(object) {

            //Save
            asking[key] = (tail, stored.cleaner)

        } else {

            //Clean
            stored.cleaner?()
            asking[key] = nil

        }

        //Handle Ask.any
        (asking["Any"]?.last as? Ask<Any>)?.head(object)

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

/// Save
/// Without triggering Askings
public
extension Wand {

    @discardableResult
    func save<T>(_ object: T, key: String? = nil) -> String {

        let result = key ?? T.self|
        Wand[object] = self
        context[result] = object

        return result
    }

    func save(sequence: any Sequence) {

        sequence.forEach { object in
            let key = type(of: object)|

            Wand[object] = self
            context[key] = object
        }

    }

}

/// Ask
/// For objects
public
extension Wand {

    func answer<T>(the ask: Ask<T>,
                   check: Bool = false) -> Bool {

        let key = ask.key
        let stored = asking[key]

        //Call handler if object exist
        //TODO: Test check with NFC
        if check, let object: T = get() {

            if !ask.handler(object) {
                return stored == nil
            }

        }

        //Attach wand
        ask.set(wand: self)

        //Add ask to chain
        let cleaner: ( ()->() )?
        if let stored {

            let last = (stored.last as! Ask<T>)
            
            ask.next = last.next
            last.next = ask

            cleaner = stored.cleaner

        } else {
            ask.next = ask
            cleaner = nil
        }

        asking.updateValue((last: ask, cleaner: cleaner),
                           forKey: key)

        return stored == nil
    }

    func setCleaner<T>(for ask: Ask<T>, cleaner: @escaping ()->()) {
        let key = ask.key
        asking[key] = (asking[key]!.last, cleaner)
    }

}

/// Wanded
extension Wand: Wanded {

    public var wand: Wand {
        self
    }

    public var isWanded: Wand? {
        self
    }

}

/// Close
public
extension Wand {

    func close() {

        //Notify .all
        (asking["All"]?.last as? Ask<Wand>)?.head(self)

        //Clean questions
        asking.forEach {
            $0.value.cleaner?()
            Wand.log("|🧼 \($0.value)")
        }
        asking.removeAll()

        //Release objects
        context.removeAll()

        //Clean Wands shelf
        Wand.all = Wand.all.filter {
            $0.value.item != nil
        }

    }

}
