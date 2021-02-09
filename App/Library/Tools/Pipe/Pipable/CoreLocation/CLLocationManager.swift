//
//  CoreLocation+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 02.11.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreLocation.CLLocation

extension CLLocationManager: Source {

    struct Ell {
        
        //kCLLocationAccuracyBestForNavigation
        //kCLLocationAccuracyBest
        //kCLLocationAccuracyNearestTenMeters
        //kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyKilometer
        //kCLLocationAccuracyThreeKilometers
        //
        //@default
        //kCLLocationAccuracyThreeKilometers
        let desiredAccuracy: CLLocationAccuracy?
        
        //@default
        //100 m
        var distanceFilter: CLLocationDistance?
        
    }
    
    static func |(from: Pipable?, _: CLLocationManager.Type) -> Self {
        let pipe = Pipe.from(from)
        
        let source = CLLocationManager()
        source.delegate = pipe.put(Delegate())
        
        let ell: Ell? = from|
        source.desiredAccuracy = ell?.desiredAccuracy ?? kCLLocationAccuracyThreeKilometers
        source.distanceFilter = ell?.distanceFilter ?? 100
        
        return pipe.put(source) as! Self
    }
    
}

extension CLLocationManager {
    
    class Delegate: NSObject, CLLocationManagerDelegate, Pipable {
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let last = locations.last {
                pipe()?.expectations?.come(for: last)
            }
            
            pipe()?.expectations?.come(for: locations)
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            pipe()?.expectations?.come(for: nil as CLLocation?, error: error)
        }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            pipe()?.expectations?.come(for: status)
        }
        
    }
    
}
