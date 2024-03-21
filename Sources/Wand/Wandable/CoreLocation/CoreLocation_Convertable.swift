//
//  CoreLocation_Convertable.swift
//  Sandbox
//
//  Created by Alex Kozin on 23.08.2022.
//

import CoreLocation.CLLocation

/**Pipe.Convertable

 public postfix func |(coordinate: CLLocationCoordinate2D)
 public postfix func |(degrees: (CLLocationDegrees, CLLocationDegrees))
 public postfix func |(location: CLLocation) -> CLLocationCoordinate2D

 func | (to: CLLocationCoordinate2D?, from: CLLocationCoordinate2D?) -> CLLocationDistance?
 func | (to: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance
 func | (to: CLLocation, from: CLLocation) -> CLLocationDistance

 #Usage
 ```
let location: CLLocation = coordinate|
 ```

 */

//CLLocation
public postfix func |(coordinate: CLLocationCoordinate2D) -> CLLocation {
    CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
}

//CLLocationCoordinate2D
public postfix func |(degrees: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: degrees.0, longitude: degrees.1)
}

public postfix func |(location: CLLocation) -> CLLocationCoordinate2D {
    location.coordinate
}

//CLLocationDistance
public func | (to: CLLocationCoordinate2D?, from: CLLocationCoordinate2D?) -> CLLocationDistance? {
    guard let to = to, let from = from else {
        return nil
    }

    return to | from
}

public func | (to: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance {
    to|.distance(from: from|)
}

public func | (to: CLLocation, from: CLLocation) -> CLLocationDistance {
    to.distance(from: from)
}
