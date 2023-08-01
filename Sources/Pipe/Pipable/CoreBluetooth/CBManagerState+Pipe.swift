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

import CoreBluetooth.CBManager

/// Ask for object
///
/// |{ (state: CBManagerState) in
///
/// }
@discardableResult
prefix func |(handler: @escaping (CBManagerState)->()) -> Pipe {
    Pipe() | Ask.every(handler: handler)
}

/// Ask for object
/// `every`, `one` or `while`
///
/// |.every { (state: CBManagerState) in
///
/// }
@discardableResult
prefix func |(ask: Ask<CBManagerState>) -> Pipe {
    Pipe() | ask
}

/// Ask for object from `context`
///
/// context | { (state: CBManagerState) in
///
/// }
@discardableResult
func |<T> (context: T, handler: @escaping (CBManagerState)->()) -> Pipe {
    context | Ask.every(handler: handler)
}

/// Ask for object from `context`
/// `every`, `one` or `while`
///
/// context | .every { (state: CBManagerState) in
///
/// }
@discardableResult
func |<T> (context: T, ask: Ask<CBManagerState>) -> Pipe {

    let pipe = Pipe.attach(to: context)

    guard pipe.ask(for: ask) else {
        return pipe
    }

    //Just construct Manager
    let _: CBCentralManager = pipe.get()
    return pipe
    
}
