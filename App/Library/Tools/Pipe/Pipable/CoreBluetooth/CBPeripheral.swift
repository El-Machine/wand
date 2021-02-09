//
//  CBPeripheral+PIpe.swift
//  Sample
//
//  Created by Alex Kozin on 18.01.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import CoreBluetooth

extension CBPeripheral: FromSource {
    
    typealias From = CBCentralManager
    typealias Ell = CBCentralManager.Ell

    static func |(from: Pipable?, _: CBPeripheral.Type) -> CBCentralManager {
        let piped: CBCentralManager = from|
        
        //Wait for state
        piped | .once { (state: CBManagerState) in
            guard state == .poweredOn else {
                return
            }
            
            let ell: CBPeripheral.Ell? = from|
            piped.scanForPeripherals(withServices: ell?.services,
                                    options: ell?.scan)
        }
        
        return piped
    }
    
    @discardableResult
    static func |(piped: CBPeripheral, handler: @escaping ([CBService])->()) -> CBPeripheral {
        piped.delegate = piped.pipe().put(Delegate())
        piped.discoverServices(nil)
        
        return piped | .once(handler)
    }
    
}


extension CBPeripheral {
    
    class Delegate: CreatableObject, CBPeripheralDelegate {
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            pipe()?.expectations?.come(for: peripheral.services, error: error)   
        }
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            pipe()?.expectations?.come(for: service.characteristics, with: service|, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            pipe()?.expectations?.come(for: characteristic, with: characteristic.uuid.uuidString, error: error)
        }
        
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
            
        }
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
            pipe()?.expectations?.come(for: characteristic.descriptors, with: characteristic|, error: error)
        }
        
    }
    
}

#if targetEnvironment(simulator)

extension CBPeripheral {
    
    static var mock: CBPeripheral {
        let mock = Mock()
        mock.addObserver(mock, forKeyPath: "delegate", options: .new, context: nil)
        
        return mock
    }
    
    class Mock: CBPeripheral {
        
        fileprivate init(_ mock: Mock? = nil) {
        }
        
    }
    
}

#endif
