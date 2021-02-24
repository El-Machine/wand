//
//  CoreLocation+PipeTypes.swift
//  Sample
//
//  Created by Alex Kozin on 07.12.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreLocation.CLLocation

extension CLLocation: FromSource {
    
    typealias From = CLLocationManager
    typealias Ell = From.Ell
    
    static func |(from: Pipable?, _: CLLocation.Type) -> CLLocationManager {
        let piped: CLLocationManager = from|
        piped.requestWhenInUseAuthorization()
        
        //Wait for state
        piped | .while { (status: CLAuthorizationStatus) in
            guard status != .notDetermined else {
                return false
            }
            
            piped.startUpdatingLocation()
            
            return true
        }
        
        return piped
    }
    
}

extension CLAuthorizationStatus: FromSource {
    
    typealias From = CLLocationManager
    typealias Ell = From.Ell
    
}

postfix func |(p: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: p.0, longitude: p.1)
}


