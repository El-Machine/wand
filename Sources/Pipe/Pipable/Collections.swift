//
//  CoreGraphicsUtils.swift
//  Sample
//
//  Created by Alex Kozin on 17.04.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import Foundation.NSIndexPath

extension Array {
    
    static postfix func |(p: Self) -> Range<Int> {
        0..<p.count
    }
    
    static postfix func |(p: Self) -> [IndexPath] {
        (0..<p.count)|
    }

}

extension Array where Element: BinaryInteger {
    
    static postfix func |(p: Self) -> Data {
        Data(p as! [UInt8])
    }
    
}


extension Range where Bound == Int {

    static postfix func |(p: Self) -> [IndexPath] {
        p.map {
            IndexPath(row: $0, section: 0)
        }
    }
    
    static postfix func |(p: Self) -> Int {
        .random(in: p)
    }
    
}

extension Range where Bound == Double {
    
    static postfix func |(p: Self) -> Double {
        .random(in: p)
    }
    
}

extension ClosedRange where Bound == Int {
    
    static postfix func |(p: Self) -> Int {
        .random(in: p)
    }
    
}

extension ClosedRange where Bound == Double {
    
    static postfix func |(p: Self) -> Double {
        .random(in: p)
    }
    
}
