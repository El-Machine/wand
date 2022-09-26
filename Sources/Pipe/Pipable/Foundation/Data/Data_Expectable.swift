//
//  Data_Expectable.swift
//  Energy
//
//  Created by Alex Kozin on 31.08.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation

extension Data: Expectable {

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {

        guard pipe.start(expecting: expectation) else {
            return
        }

        let task = piped as? URLSessionDataTask ?? pipe.get()
        task.resume()
    }


}
