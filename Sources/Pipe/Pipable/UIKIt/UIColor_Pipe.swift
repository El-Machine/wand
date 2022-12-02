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

#if canImport(UIKit)
import UIKit.UIImage

public postfix func |(name: String) -> UIColor {
    UIColor(named: name)!
}

//public postfix func |(hex: String) -> UIColor? {
//    hex | 1
//}

public func |(hex: String, alpha: CGFloat) -> UIColor? {
    var string = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if string.hasPrefix("#") {
        string.removeFirst()
    }
    
    guard string.count == 6 else {
        return nil
    }
    
    var rgb: UInt64 = 0
    Scanner(string: string).scanHexInt64(&rgb)
    
    return UIColor(red:     CGFloat((rgb & 0xFF0000) >> 16  ) / 255.0,
                   green:   CGFloat((rgb & 0x00FF00) >> 8   ) / 255.0,
                   blue:    CGFloat((rgb & 0x0000FF)        ) / 255.0,
                   alpha:   alpha)
}

public func |(color: UIColor, alpha: CGFloat) -> UIColor {
    color.withAlphaComponent(alpha)
}

public postfix func |(piped: (white: CGFloat, alpha:CGFloat)) -> UIColor {
    UIColor(white: piped.white, alpha: piped.alpha)
}

public postfix func |<T: FixedWidthInteger>(color: T) -> UIColor {
    color | 1
}

public func |<T: FixedWidthInteger>(color: T, alpha: CGFloat) -> UIColor {
    UIColor(red:  CGFloat((color & 0xFF0000) >> 16) / 255.0,
            green:  CGFloat((color & 0x00FF00) >> 8) / 255.0,
            blue:  CGFloat((color & 0x0000FF)) / 255.0,
            alpha: alpha)
}

#endif
