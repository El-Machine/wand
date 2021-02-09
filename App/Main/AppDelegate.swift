//
//  AppDelegate.swift
//  Sample
//
//  Created by Alex Kozin on 06/02/2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreMotion
import CoreBluetooth
import CoreLocation

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        #if DEBUG
            print("DEBUG MODE")
            UIApplication.shared.isIdleTimerDisabled = true
        #endif
        
//        location()
//        motion()
    }
    
    func motion() {
        |{ (event: CMPedometerEvent) in
            print("Event: %@", event)
        }
        
        |{ (data: CMPedometerData) in
            print("Data: %@", data)
        }
    }
    
    func bluetooth() {
        |{ (state: CBManagerState) in
            print(state.rawValue)
        }
        
        |{ (p: CBPeripheral) in
            print(p)
        }
        
        CBPeripheral.Ell(queue: .main) | { (p: CBPeripheral) in
            print(p)
            
            p.pipe().close()
        }
    }
    
    func location() {
        |{ (location: CLLocation) in
            print("Location updated to:\n %@", location)
            
            location.pipe().close()
        } | { (status: CLAuthorizationStatus) in
            print("Location authorization status updated to: \(status.rawValue)")
        }
        
    }

}
