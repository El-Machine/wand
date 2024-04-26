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

import Foundation

extension Bool {

    static public postfix func |<T: Numeric> (value: Self) -> T {
        value ? 1 : 0
    }

}

extension BinaryInteger {

    static public postfix func |(value: Self) -> Double {
        Double(value)
    }

    static public postfix func |(value: Self) -> CGFloat {
        CGFloat(value)
    }

}

extension Double {
    
    static public postfix func |(value: Self) -> Float {
        Float(value)
    }
    
}

extension String {
    
    static public postfix func |(value: Self) -> Int? {
        Int(value) ?? Int(String(value.unicodeScalars.filter(CharacterSet.decimalDigits.inverted.contains)))
    }
    
    static public postfix func |(value: Self) -> Int {
        (value|)!
    }
    
}

extension BinaryFloatingPoint {

    public static postfix func |(value: Self) -> Int {
        Int(value)
    }

}

public postfix func |(value: String?) -> Double? {
    Double(value ?? "")
}
