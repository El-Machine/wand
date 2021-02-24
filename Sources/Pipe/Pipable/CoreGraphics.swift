//
//  CoreGraphics+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 04.10.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import UIKit.UIGeometry

//CGPoint
postfix func |(p: (x: CGFloat, y: CGFloat)) -> CGPoint {
    CGPoint(x: p.0, y: p.1)
}

//CGRect
postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> CGRect {
    CGRect(x: p.0, y: p.1, width: p.2, height: p.3)
}

extension CGRect {
    
    static postfix func |(p: Self) -> UIView {
        UIView(frame: p)
    }
    
}

//CGSize
postfix func |(p: CGFloat) -> CGSize {
    CGSize(width: p, height: p)
}

postfix func |(p: (width: CGFloat, height: CGFloat)) -> CGSize {
    CGSize(width: p.0, height: p.1)
}

//UIEdgeInsets
postfix func |(p: (CGFloat, CGFloat, CGFloat, CGFloat)) -> UIEdgeInsets {
    UIEdgeInsets(top: p.0, left: p.1, bottom: p.2, right: p.3)
}

//UIView
postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> UIView {
    UIView(frame: CGRect(x: p.0, y: p.1, width: p.2, height: p.3))
}
