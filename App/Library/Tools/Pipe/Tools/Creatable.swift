//
//  Creatable.swift
//  Sample
//
//  Created by Alex Kozin on 09.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import ObjectiveC

protocol Creatable: Pipable {
    
    init()
    
}

class CreatableObject: NSObject, Creatable {
    
    required override init() {
    }
    
}
