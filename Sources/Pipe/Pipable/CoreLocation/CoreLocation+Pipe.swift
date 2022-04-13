//  Copyright © 2020-2022 Alex Kozin
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//  2022 Alex Kozin
//

import CoreLocation.CLLocation

extension CLLocation: Expectable {

    static func produce<T>(with: Any?, on pipe: Pipe, expecting: Event<T>) {
        let source = with as? CLLocationManager ?? pipe.get()
        let request = with as? CLAuthorizationStatus ?? pipe.get()

        (request ?? source) | .while { (status: CLAuthorizationStatus) -> Bool in
            guard status != .notDetermined else {
                return true
            }

            switch (expecting.condition) {
                case .every, .while:
                    source.startUpdatingLocation()

                default:
                    source.requestLocation()
            }

            return false
        }
    }

}

extension CLAuthorizationStatus: Expectable {

    static func produce<T>(with: Any?, on pipe: Pipe, expecting: Event<T>) {
        let source = with as? CLLocationManager ?? pipe.get()

        switch with as? CLAuthorizationStatus {
#if !APPCLIP
            case .authorizedAlways:
                source.requestAlwaysAuthorization()
#endif

            case .authorizedWhenInUse, .none:
                source.requestWhenInUseAuthorization()

            default:
                break
        }
    }

    static postfix func |(type: CLAuthorizationStatus.Type) -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return CLLocationManager().authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
}



postfix func |(p: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: p.0, longitude: p.1)
}

postfix func |(p: CLLocation) -> CLLocationCoordinate2D {
    p.coordinate
}

postfix func |(p: CLLocationCoordinate2D) -> CLLocation {
    CLLocation(latitude: p.latitude, longitude: p.longitude)
}
