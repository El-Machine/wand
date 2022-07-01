//  Copyright (c) 2020-2022 El Machine (http://el-machine.com/)
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
//  2020 El Machine
//

import MapKit

protocol Num {

    var double: Double {get}
    var int: Int {get}

}

extension Num where Self: BinaryFloatingPoint {

    var double: Double {
        Double(self)
    }

    var int: Int {
        Int(self)
    }

}

extension Num where Self: BinaryInteger {

    var double: Double {
        Double(self)
    }

    var int: Int {
        Int(self)
    }

}

extension Double: Num {
}

extension CGFloat: Num {
}

extension Float: Num {
}

extension Int: Num {
}

//extension MKMapPoint {

postfix func |(piped: CLLocationCoordinate2D) -> MKMapPoint {
    MKMapPoint(piped)
}

postfix func |(piped: CLLocation) -> MKMapPoint {
    MKMapPoint(piped.coordinate)
}

//postfix func |<T: BinaryFloatingPoint, U: BinaryFloatingPoint>(piped: (x: T, y: U)) -> MKMapPoint {
//    MKMapPoint(x: Double(piped.x), y: Double(piped.y))
//}

postfix func |<T: Num, U: Num>(piped: (x: T, y: U)) -> MKMapPoint {
    MKMapPoint(x: piped.x.double, y: piped.x.double)
}

//}

//extension MKMapSize {

postfix func |(piped: Double) -> MKMapSize {
    MKMapSize(width: piped, height: piped)
}

//}

//extension MKMapRect {

func |(piped: MKMapPoint, size: MKMapSize) -> MKMapRect {
    MKMapRect(origin: piped, size: size).offsetBy(dx: -size.width / 2,
                                                  dy: -size.height / 2)
}

func |(piped: MKMapPoint, side: Double) -> MKMapRect {
    MKMapRect(origin: piped, size: side|).offsetBy(dx: -side / 2, dy: -side / 2)
}

//}
