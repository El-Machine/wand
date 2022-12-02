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

import CoreGraphics

//CGPoint
public postfix func |(p: (x: CGFloat, y: CGFloat)) -> CGPoint {
    CGPoint(x: p.0, y: p.1)
}

public postfix func |(piped: Int) -> CGPoint {
    CGPoint(x: piped, y: piped)
}

//CGRect
public postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> CGRect {
    CGRect(x: p.0, y: p.1, width: p.2, height: p.3)
}

public postfix func |(size: CGSize) -> CGRect {
    CGRect(origin: .zero, size: size)
}

//CGSize
public postfix func |(p: CGFloat) -> CGSize {
    CGSize(width: p, height: p)
}

public postfix func |(p: (width: CGFloat, height: CGFloat)) -> CGSize {
    CGSize(width: p.0, height: p.1)
}

public postfix func |(p: (width: Int, height: Int)) -> CGSize {
    CGSize(width: CGFloat(p.0), height:  CGFloat(p.1))
}
