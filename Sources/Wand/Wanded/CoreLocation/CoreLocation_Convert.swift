/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

import CoreLocation.CLLocation

/// Convert
///
/// let location: CLLocation = coordinate|
///

//CLLocation
@inline(__always)
public 
postfix func |(coordinate: CLLocationCoordinate2D) -> CLLocation {
    CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
}

//CLLocationCoordinate2D
@inline(__always)
public 
postfix func |(degrees: (CLLocationDegrees, CLLocationDegrees)) -> CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: degrees.0, longitude: degrees.1)
}

@inline(__always)
public 
postfix func |(location: CLLocation) -> CLLocationCoordinate2D {
    location.coordinate
}

//CLLocationDistance
@inline(__always)
public 
func | (to: CLLocationCoordinate2D?, from: CLLocationCoordinate2D?) -> CLLocationDistance? {
    guard let to = to, let from = from else {
        return nil
    }

    return to | from
}

@inline(__always)
public 
func | (to: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance {
    to|.distance(from: from|)
}

@inline(__always)
public 
func | (to: CLLocation, from: CLLocation) -> CLLocationDistance {
    to.distance(from: from)
}
