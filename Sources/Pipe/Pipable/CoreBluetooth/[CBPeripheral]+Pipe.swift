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

import CoreBluetooth.CBPeripheral

@discardableResult
public
func |<T> (context: T, ask: Ask<[CBPeripheral]>.Retrieve) -> Pipe {

    let pipe = Pipe.attach(to: context)

    let source: CBCentralManager    = pipe.get()
    let ids: [UUID]                 = pipe.get() ?? []

    let peripherals = source.retrievePeripherals(withIdentifiers: ids)
    _ = ask.handler(peripherals)

    pipe.closeIfDone()

    return pipe
}


@discardableResult
public
func |<T> (context: T, ask: Ask<[CBPeripheral]>.RetrieveConnected) -> Pipe {

    let pipe = Pipe.attach(to: context)

    let source: CBCentralManager = pipe.get()
    let connected = source.retrieveConnectedPeripherals(withServices: pipe.get() ?? [])

    _ = ask.handler(connected)

    pipe.closeIfDone()

    return pipe
}

@discardableResult
public
prefix func |(ask: Ask<[CBPeripheral]>.Retrieve) -> Pipe {
    Pipe() | ask
}

@discardableResult
public
prefix func |(ask: Ask<[CBPeripheral]>.RetrieveConnected) -> Pipe {
    Pipe() | ask
}

public
extension Ask {

    class Retrieve: Ask {
    }

    class RetrieveConnected: Ask {
    }

}

public
extension Ask where T == Array<CBPeripheral> {

    static func retrieve(handler: @escaping (T)->() ) -> Retrieve {
        .one(handler: handler)
    }


    static func retrieveConnected(handler: @escaping (T)->() ) -> RetrieveConnected {
        .one(handler: handler)
    }

}
