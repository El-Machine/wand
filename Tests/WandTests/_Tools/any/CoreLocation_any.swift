//
//  CoreLocation_any.swift
//  toolburator
//
//  Created by Alex Kozin on 17.05.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import CoreLocation.CLLocation

extension CLLocationAccuracy: Any_ {

    static var any: Self {
        [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers,
        ].randomElement()!

    }

}

extension CLLocationCoordinate2D: Any_ {

    static var any: Self {
        Self(latitude: .any(in: -90...90), longitude: .any(in: -180...180))
    }

}

extension CLLocation: Any_ {

    static var any: Self {
        Self.init(coordinate: .any,
                  altitude: .any,
                  horizontalAccuracy: .any,
                  verticalAccuracy: .any,
                  timestamp: .any)
    }

}
