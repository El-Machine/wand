//
//  Pipe+Debug.swift
//  Sample
//
//  Created by Alex Kozin on 11.02.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

#if DEBUG
import Foundation

extension Pipe: CustomStringConvertible {
    
    static func all() -> [Pipe] {
        pipes.map {
            $1
        }.reduce([Pipe]()) { (result, candidat) -> [Pipe] in
            let first = result.first {
                $0 === candidat
            }
            
            if first == nil {
                return result + [candidat]
            } else {
                return result
            }
        }
    }
    
    var description: String {
        """
        <Pipe \(String(describing: Unmanaged.passUnretained(self).toOpaque()))>
        """
//        <Pipe \(String(describing: Unmanaged.passUnretained(self).toOpaque()))> piped:
//        \(piped.reduce("") {
//            $0 + String(describing: $1) + "\n"
//        })
    }
    
    static func printLog() {
        print("Total pipes: \n %@ \n", Pipe.all())
    }
    
}
#endif
