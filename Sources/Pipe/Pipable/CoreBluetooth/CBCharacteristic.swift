//
//  CBCharacteristic+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 15.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import CoreBluetooth

extension CBCharacteristic: Pipable {
    
    @discardableResult
    static func |(from: CBCharacteristic, handler: @escaping ([CBDescriptor])->()) -> CBCharacteristic {
        from.service.peripheral.discoverDescriptors(for: from)
        return from | .once(from|, handler: handler)
    }
    
    @discardableResult
    static func |(from: CBCharacteristic, handler: @escaping (Data)->()) -> CBCharacteristic {
        from.service.peripheral.setNotifyValue(true, for: from)
        return from | .every(from|, handler: handler)
    }
    
}

@discardableResult
func |(from: CBUUID, handler: @escaping (CBCharacteristic)->()) -> CBUUID {
    
    guard let periphiral: CBPeripheral = from.pipe()?.get() else {
        return from
    }
    
    periphiral | { (services: [CBService]) in
        services.forEach {
            
            $0 | { (c: [CBCharacteristic]) in
                let characteristic = c.first {
                    $0.uuid == from
                }
                
                if let characteristic = characteristic {
                    periphiral.setNotifyValue(true, for: characteristic)
                }
            }
            
        }
    }
    
    return from | .every(from.uuidString, handler: handler)
}
