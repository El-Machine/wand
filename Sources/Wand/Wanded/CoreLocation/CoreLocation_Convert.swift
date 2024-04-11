//
//  CoreLocation_Convertable.swift
//  Sandbox
//
//  Created by Alex Kozin on 23.08.2022.
//

import CoreLocation.CLLocation

/// Convert
///
/// let location: CLLocation = coordinate|
///

//CLLocation
@inline(__always)
public postfix func |(coordinate: CLLocationCoordinate2D) -> CLLocation {
    CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
}

//CLLocationCoordinate2D
@inline(__always)
public postfix func |(degrees: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: degrees.0, longitude: degrees.1)
}

@inline(__always)
public postfix func |(location: CLLocation) -> CLLocationCoordinate2D {
    location.coordinate
}

//CLLocationDistance
@inline(__always)
public func | (to: CLLocationCoordinate2D?, from: CLLocationCoordinate2D?) -> CLLocationDistance? {
    guard let to = to, let from = from else {
        return nil
    }

    return to | from
}

@inline(__always)
public func | (to: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance {
    to|.distance(from: from|)
}

@inline(__always)
public func | (to: CLLocation, from: CLLocation) -> CLLocationDistance {
    to.distance(from: from)
}
