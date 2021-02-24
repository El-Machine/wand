//
//  CoreBluetooth+PipeTypes.swift
//  Sample
//
//  Created by Alex Kozin on 09.12.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreBluetooth

extension CBManagerState: FromSource {
    
    typealias From = CBCentralManager
    typealias Ell = CBCentralManager.Ell
    
}

extension CBService: Pipable {
    
    @discardableResult
    static func |(from: CBService, handler: @escaping ([CBCharacteristic])->()) -> CBService {
        from.peripheral.discoverCharacteristics(from.pipe().get(), for: from)
        return from | .once(from|, handler: handler)
    }
    
}

extension CBUUID: Pipable {
    
}
