/// Copyright © 2020-2024 El Machine 🤖
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

#if canImport(UIKit)
import UIKit

//IndexPath
extension Array {
    
    static public postfix func |(p: Self) -> [IndexPath] {
        (0..<p.count)|
    }
}

extension Range where Bound == Int {

    static public postfix func |(p: Self) -> [IndexPath] {
        p.map {
            IndexPath(row: $0, section: 0)
        }
    }

}

extension ClosedRange where Bound == Int {

    static public postfix func |(p: Self) -> [IndexPath] {
        p.map {
            IndexPath(row: $0, section: 0)
        }
    }

}

public postfix func |(piped: (row: Int, section: Int)) -> IndexPath {
    IndexPath(row: piped.row, section: piped.section)
}

//UIEdgeInsets
public postfix func |(piped: (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)) -> UIEdgeInsets {
    UIEdgeInsets(top: piped.top,
                 left: piped.left,
                 bottom: piped.bottom,
                 right: piped.right)
}

public postfix func |(piped: (CGFloat)) -> UIEdgeInsets {
    UIEdgeInsets(top: piped, left: piped, bottom: piped, right: piped)
}

public postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> UIView {
    UIView(frame: CGRect(x: p.0, y: p.1, width: p.2, height: p.3))
}

//UITextRange

//extension UITextPosition: Pipable {
//
//}
//
//public
//postfix func |(p: UITextPosition) -> Int {
//        let field: UITextField = p.pipe.get()!
//        return field.offset(from: field.beginningOfDocument, to: p)
//}

//UIBezierPath
public postfix func |(p: CGRect) -> UIBezierPath {
    UIBezierPath(rect: p)
}

public postfix func |(p: (rect: CGRect, radius: CGFloat)) -> UIBezierPath {
    UIBezierPath(roundedRect: p.rect, cornerRadius: p.radius)
}

public postfix func |(p: (rect: CGRect, rounding: UIRectCorner, radii: CGSize)) -> UIBezierPath {
    UIBezierPath(roundedRect: p.rect, byRoundingCorners: p.rounding, cornerRadii: p.radii)
}

//UIImage
public postfix func |(p: String) -> UIImage {
    (p|)!
}

@inline(__always)
public postfix func |(piped: String) -> UIImage? {
    UIImage(named: piped)
}

public postfix func |(p: String?) -> UIImage? {
    guard let name = p else {
        return nil
    }
    
    return name|
}

#endif
