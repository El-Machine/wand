//
//  CoreMotion+Pipe.swift
//  Sample
//
//  Created by Alex Kozin on 04.10.2020.
//  Copyright © 2020 El Machine. All rights reserved.
//

import CoreMotion.CMPedometer

extension CMPedometer: Source {
   
    static func |(from: Pipable?, _: CMPedometer.Type) -> Self {
        Pipe.from(from).put(CMPedometer()) as! Self
    }
    
}

extension CMPedometerEvent: FromSource {
    
    typealias From = CMPedometer
    
    @discardableResult
    static func | (from: Pipable?, _: CMPedometerEvent.Type) -> CMPedometer {
        let piped: CMPedometer = from|
        piped.startEventUpdates { (event, error) in
            piped.pipe()?.expectations?.come(for: event, error: error)
        }

        return piped
    }
    
}

extension CMPedometerData: FromSource {
    
    typealias From = CMPedometer
    
    @discardableResult
    static func | (from: Pipable?, _: CMPedometerData.Type) -> CMPedometer {
        let piped: CMPedometer = from|
        piped.startUpdates(from: Date()) { (data, error) in
            piped.pipe()?.expectations?.come(for: data, error: error)
        }

        return piped
    }
    
}
