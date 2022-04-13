//
//  MapKit+Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 13.01.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import MapKit

postfix func |(p: CLLocationCoordinate2D) -> MKMapPoint {
    MKMapPoint(p)
}
