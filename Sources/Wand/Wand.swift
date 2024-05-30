///
/// Copyright © 2020-2024 El Machine 🤖
/// https://el-machine.com/
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
/// 1) .LICENSE
/// 2) https://apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
/// Created by Alex Kozin
/// 2020 El Machine

import Foundation

/// Wand
/// Bus for <#Any#> Factory + Cache
public
final
class Wand {

    public
    struct Weak {
        weak var item: Wand?
    }

    public
    static 
    var all = [Int: Wand.Weak]()

    internal
    static
    subscript <T> (_ object: T?) -> Wand? {

        get { if let object {
            return Wand[object]
        } else {
            return nil
        }}

        set { if let object {
            Wand[object] = newValue
        }}

    }

    @inline(__always)
    internal
    static
    subscript <T> (_ object: T) -> Wand? {

        get { if T.self is AnyClass {
            let key = unsafeBitCast(object, to: Int.self)
            return all[key]?.item
        } else {
            return nil
        }}

        set { if T.self is AnyClass, let wand = newValue {
            let key = unsafeBitCast(object, to: Int.self)
            all[key] = Weak(item: wand)
        }}

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

    convenience
    public
    init<T>(for object: T) {
        self.init()

        Wand[object] = self
        context[T.self|] = object
    }

    deinit {
        close()
        log("|✅ #bonsua\n\(self)\n")
    }

}

/// Attach to Any?
extension Wand {

    public
    static 
    func to<C>(_ context: C? = nil) -> Wand {

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

    func get<T>(for key: String? = nil, or create: @autoclosure ()->(T) ) -> T {
        get(for: key) ?? {
            let object = create()
            save(object, key: key)

            return object
        }()
    }

}

/// Add object
/// Satisfy action
public
extension Wand {

    @discardableResult
    func add<T>(_ object: T, for raw: String? = nil) -> T {

        //Retreive key for saved
        let key = save(object, key: raw)

        //Answer questions
        guard
            let stored = asking[key]
        else {
            return object
        }

        //From head
        if let tail = (stored.last as? Ask<T>)?.head(object)
        {
            //Save
            asking[key] = (tail, stored.cleaner)
        } 
        else
        {
            //Clean
            stored.cleaner?()
            asking[key] = nil
        }

        //Handle Ask.any
        (asking["Any"]?.last as? Ask<Any>)?.head(object)

        return object
    }

    @discardableResult
    @inline(__always)
    func addIf<T>(exist object: T?, for key: String? = nil) -> T? {
        
        guard let object = object else {
            return nil
        }

        return add(object, for: key)
    }

}

/// Check object availability
/// Context contains
public
extension Wand {

    @discardableResult
    @inline(__always)
    func contains(_ key: String) -> Any? {
        context.keys.contains(key)
    }

}

/// Remove
/// Without triggering
public
extension Wand {

    @discardableResult
    @inline(__always)
    func extract<T>(_ key: String? = nil) -> T? {
        context.removeValue(forKey: key ?? T.self|) as? T
    }

}

/// Save
/// Without triggering Asks
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
        if check, let object: T = get() {

            if !ask.handler(object) {
                return stored != nil
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

    func setCleaner<T>(for ask: Ask<T>, cleaner: @escaping ()->() ) {
        let key = ask.key
        asking[key] = (asking[key]!.last, cleaner)
    }

}

/// Wanded
extension Wand: Wanded {

    public
    var wand: Wand {
        self
    }

    public
    var isWanded: Wand? {
        self
    }

}

/// Close
extension Wand {

    public
    func close() {

        //Handle Ask.all
        (asking["All"]?.last as? Ask<Wand>)?.head(self)

        //Remove questions
        asking.forEach {
            $0.value.cleaner?()
            log("|🧼 \($0.value)")
        }
        asking.removeAll()

        //Release context
        context.removeAll()

        //Clean Wands shelf
        Wand.all = Wand.all.filter {
            $0.value.item != nil
        }
    }

}
