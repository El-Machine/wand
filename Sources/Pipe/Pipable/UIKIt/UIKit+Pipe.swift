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

#if canImport(UIKit)
import UIKit

//IndexPath
extension Array {
    
    static postfix func |(p: Self) -> [IndexPath] {
        (0..<p.count)|
    }
}

extension Range where Bound == Int {

    static postfix func |(p: Self) -> [IndexPath] {
        p.map {
            IndexPath(row: $0, section: 0)
        }
    }

}

extension ClosedRange where Bound == Int {

    static postfix func |(p: Self) -> [IndexPath] {
        p.map {
            IndexPath(row: $0, section: 0)
        }
    }

}

postfix func |(p: (Int, Int)) -> IndexPath {
    IndexPath(row: p.0, section: p.1)
}

//UIEdgeInsets
postfix func |(p: (CGFloat, CGFloat, CGFloat, CGFloat)) -> UIEdgeInsets {
    UIEdgeInsets(top: p.0, left: p.1, bottom: p.2, right: p.3)
}

//UIView
extension UIView {
    
    static postfix func |(p: UIView) -> CGSize {
        p.frame.size
    }
    
    static func | (view: UIView, contentMode: ContentMode) -> Self {
        view.contentMode = contentMode
        return view as! Self
    }
    
}

postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> UIView {
    UIView(frame: CGRect(x: p.0, y: p.1, width: p.2, height: p.3))
}

extension CGRect {
    
    static postfix func |(p: Self) -> UIView {
        UIView(frame: p)
    }
    
}

//UITextRange
extension UITextPosition: Pipable {
    
    static postfix func |(p: UITextPosition) -> Int {
        let field: UITextField = p.pipe.get()!
        return field.offset(from: field.beginningOfDocument, to: p)
    }
    
}

//UIBezierPath
postfix func |(p: CGRect) -> UIBezierPath {
    UIBezierPath(rect: p)
}

postfix func |(p: (rect: CGRect, radius: CGFloat)) -> UIBezierPath {
    UIBezierPath(roundedRect: p.rect, cornerRadius: p.radius)
}

postfix func |(p: (rect: CGRect, rounding: UIRectCorner, radii: CGSize)) -> UIBezierPath {
    UIBezierPath(roundedRect: p.rect, byRoundingCorners: p.rounding, cornerRadii: p.radii)
}

//UIImage
postfix func |(p: String) -> UIImage {
    UIImage(named: p)!
}

postfix func |(p: String?) -> UIImage? {
    guard let name = p else {
        return nil
    }
    
    return UIImage(named: name)
}

//Animations
func |(p: TimeInterval, blocks: (animations: ()->Void, completion: (Bool)->Void)) {
    UIView.animate(withDuration: p, animations: blocks.animations, completion: blocks.completion)
}

func |(p: TimeInterval, animations: @escaping ()->Void) {
    UIView.animate(withDuration: p, animations: animations)
}

#endif
