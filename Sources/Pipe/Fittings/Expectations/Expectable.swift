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
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2022 Alex Kozin
//

/**
 Expectable is object that we can expect from Pipe
 - Without anything
 - With incoming objects

 Adds funcs for expecting
 - every object of type
 - only one object of type
 - while the condition is met
 */
protocol Expectable: Producer {

}

/**
 From noting
 Objects that can be produced without any data

 |{ T in

 } | H?
 */
@discardableResult
prefix func |<E: Expectable> (handler: @escaping (E)->()) -> Pipe {
    |.every(handler: handler)
}

prefix func |<E: Expectable, P> (handler: @escaping (E)->()) -> P? {
    (|handler).get()
}

/**
 Expect event
 - every
 - once
 - while

 |.once { E in

 }
 */
@discardableResult
prefix func |<E: Expectable> (event: Event<E>) -> Pipe {
    Pipe().expect(event, with: nil)
}

prefix func |<E: Expectable, P> (event: Event<E>) -> P? {
    (|event).get()
}

/**
 From object
 Objects that can be produced with concrete data

 Any? | { E in

 }
 */
@discardableResult
func |<E: Expectable> (piped: Any?, handler: @escaping (E)->()) -> Pipe {
    piped | .every(handler: handler)
}

func |<E: Expectable, P> (piped: Any?, handler: @escaping (E)->()) -> P? {
    (piped | handler).get()
}

/**
 Expect event from object
 Some objects requires concrete data to be produced

 Put incoming data to pipe and start expecting object:
 - `every` object in Pipe
 - `once` only
 - `while` returns true

 Any? | .once { E in

 }
 */
@discardableResult
func |<E: Expectable> (piped: Any?, event: Event<E>) -> Pipe {
    ((piped as? Pipable)?.pipe ?? Pipe()).expect(event, with: piped)
}

func |<E: Expectable, P> (piped: Any?, event: Event<E>) -> P? {
    (piped | event).get()
}
