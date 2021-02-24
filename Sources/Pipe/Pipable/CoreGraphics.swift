//
//  CoreGraphics+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 04.10.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreGraphics

//CGPoint
postfix func |(p: (x: CGFloat, y: CGFloat)) -> CGPoint {
    CGPoint(x: p.0, y: p.1)
}

//CGRect
postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> CGRect {
    CGRect(x: p.0, y: p.1, width: p.2, height: p.3)
}

//CGSize
postfix func |(p: CGFloat) -> CGSize {
    CGSize(width: p, height: p)
}

postfix func |(p: (width: CGFloat, height: CGFloat)) -> CGSize {
    CGSize(width: p.0, height: p.1)
}
