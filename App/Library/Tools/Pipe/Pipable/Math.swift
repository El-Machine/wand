//
//  Math+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 02.11.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreGraphics
import UIKit.UIView

extension Bool {
    
    static postfix func |<T: Numeric> (p: Self) -> T {
        p ? 1 : 0
    }

}

extension Int {

    static postfix func |(p: Self) -> IndexSet {
        IndexSet(0...p)
    }
    
    static postfix func |(p: Self) -> IndexPath {
        IndexPath(row: p, section: 0)
    }
    
    static postfix func |(p: Self) -> [IndexPath] {
        [p|]
    }

}
