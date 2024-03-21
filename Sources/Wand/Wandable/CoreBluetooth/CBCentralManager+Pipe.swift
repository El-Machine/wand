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

import CoreBluetooth.CBCentralManager

extension CBCentralManager: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        pipe.put(Self(delegate: pipe.put(Delegate()),
                    queue: pipe.get(),
                    options: pipe.get(for: "CBCentralManagerOptions")))
    }
    
    class Delegate: NSObject, CBCentralManagerDelegate, Pipable {
        
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            isPiped?.put(central.state)
        }
        
        func centralManager(_ central: CBCentralManager,
                            didDiscover peripheral: CBPeripheral,
                            advertisementData: [String : Any],
                            rssi RSSI: NSNumber) {
            isPiped?.put(peripheral)
            isPiped?.put((peripheral, advertisementData, RSSI))
        }
        
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            isPiped?.put(peripheral, key: "didConnect")
        }
        
        func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
            isPiped?.put(error)
        }
        
        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {

            if let error = error {
                isPiped?.put(error)
                return
            }

            isPiped?.put(peripheral, key: "didDisconnectPeripheral")
        }
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            if let error = error {
                isPiped?.put(error)
                return
            }

            isPiped?.put(peripheral.services)
        }
        
    }
    
}
