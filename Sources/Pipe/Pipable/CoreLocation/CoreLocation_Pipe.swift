//  Copyright © 2020-2022 El Machine 🤖
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
//

import CoreLocation.CLLocation

/**Pipable

 prefix | (handler: (CLLocation)->() ) -> Pipe
 prefix | (handler: (CLAuthorizationStatus)->() ) -> Pipe

 #Usage
 ```
 |{ (location: CLLocation) in

 }
 ```

 */

extension CLLocation: Asking, Expectable {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        let source = with as? CLLocationManager ?? pipe.get()

        let handler = { (status: CLAuthorizationStatus) -> Bool in
            guard status != .notDetermined else {
                return true
            }

            switch (expect.condition) {
                case .one:
                    source.requestLocation()

                default:
                    source.startUpdatingLocation()
            }

            return false
        }

        //Expect specific status
        if let status = with as? CLAuthorizationStatus ?? pipe.get() {
            status | .while(handler: handler).inner()
        } else {
            //Or start expecting from specific manager
            source | .while(handler: handler).inner()
        }

        expect.cleaner = {
            source.stopUpdatingLocation()
        }
    }

}

extension CLAuthorizationStatus: Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
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

//CLLocationCoordinate2D
postfix func |(p: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: p.0, longitude: p.1)
}

postfix func |(p: CLLocation) -> CLLocationCoordinate2D {
    p.coordinate
}

//CLLocation
postfix func |(p: CLLocationCoordinate2D) -> CLLocation {
    CLLocation(latitude: p.latitude, longitude: p.longitude)
}

//CLLocationDistance
func | (piped: CLLocationCoordinate2D?, from: CLLocationCoordinate2D?) -> CLLocationDistance? {
    guard let left = piped, let right = from else {
        return nil
    }

    return left|.distance(from: right|)
}

func | (piped: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance {
    piped|.distance(from: from|)
}

func | (piped: CLLocation, from: CLLocation) -> CLLocationDistance {
    piped.distance(from: from)
}
