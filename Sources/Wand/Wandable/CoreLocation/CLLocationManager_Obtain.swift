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

/// Obtain
///
/// let manager: CLLocationManager = nil|
///
extension CLLocationManager: Obtain {

    public static func obtain(by wand: Wand?) -> Self {

        let source = Self()
        source.desiredAccuracy = wand?.get(for: "CLLocationAccuracy") ??                                                     kCLLocationAccuracyThreeKilometers

        source.distanceFilter = wand?.get(for: "CLLocationDistance") ?? 100

        let wand = wand ?? Wand()
        source.delegate = wand.add(Delegate())

        return source
    }
    
}

extension CLLocationManager {
    
    class Delegate: NSObject, CLLocationManagerDelegate, Wanded {

        func locationManager(_ manager: CLLocationManager, 
                             didUpdateLocations locations: [CLLocation]) {

            if let last = locations.last {
                isWanded?.add(last)
            }

            if locations.count > 1 {
                isWanded?.add(locations)
            }

        }

        func locationManager(_ manager: CLLocationManager, 
                             didFailWithError error: Error) {

            isWanded?.add(error)

        }

        func locationManager(_ manager: CLLocationManager, 
                             didChangeAuthorization status: CLAuthorizationStatus) {

            isWanded?.add(status)

        }
        
    }
    
}
