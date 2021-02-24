//
//  Math+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 02.11.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import Foundation

extension Bool {
    
    static postfix func |<T: Numeric> (p: Self) -> T {
        p ? 1 : 0
    }

}

extension Int {

    static postfix func |(p: Self) -> IndexSet {
        IndexSet(0...p)
    }

}
