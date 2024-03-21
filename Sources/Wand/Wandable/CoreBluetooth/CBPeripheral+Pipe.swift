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

extension CBPeripheral: Pipable {
    
}

@discardableResult
public
func |<T> (context: T, ask: Ask<CBPeripheral>) -> Pipe {

    let pipe = Pipe.attach(to: context)

    guard pipe.ask(for: ask) else {
        return pipe
    }

    let source: CBCentralManager = pipe.get()
    source | .while { (status: CBManagerState) -> Bool in
        guard status == .poweredOn else {
            return true
        }

        let services: [CBUUID]?         = pipe.get()
        let options: [String : Any]?    = pipe.get()

        source.scanForPeripherals(withServices: services,
                                  options: options)

        return false
    }

    ask.cleaner = {
        source.stopScan()
    }

    return pipe
}

@discardableResult
public
prefix func |(ask: Ask<CBPeripheral>) -> Pipe {
    Pipe() | ask
}

@discardableResult
public
prefix func |(handler: @escaping (CBPeripheral)->()) -> Pipe {
    Pipe() | .every(handler: handler)
}

@discardableResult
public
func |<T> (context: T, handler: @escaping (CBPeripheral)->()) -> Pipe {
    context | .every(handler: handler)
}

public
extension CBPeripheral {

    class Delegate: NSObject, CBPeripheralDelegate, Pipable {

        public
        func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverServices error: Error?) {
            isPiped?.put(peripheral.services)
            //, error: error)
        }

        public
        func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverCharacteristicsFor service: CBService,
                        error: Error?) {
            isPiped?.put(service.characteristics, key: service.uuid.uuidString)
            //, error: error)
        }

        public
        func peripheral(_ peripheral: CBPeripheral,
                        didUpdateValueFor characteristic: CBCharacteristic,
                        error: Error?) {
            isPiped?.put(characteristic, key: characteristic.uuid.uuidString)
            //, error: error)
        }

        public 
        func peripheral(_ peripheral: CBPeripheral,
                        didDiscoverDescriptorsFor characteristic: CBCharacteristic,
                        error: Error?) {
            isPiped?.put(characteristic.descriptors,
                         key: characteristic.uuid.uuidString)
        }
        
    }
    
}
