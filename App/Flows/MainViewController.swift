//
//  MainViewController.swift
//  Sample
//
//  Created by Alex Kozin on 13.01.2021.
//  Copyright © 2021 El Machine. All rights reserved.
//

import UIKit

import CoreBluetooth
import CoreLocation
import CoreMotion

class MainViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        |{ (l: CLLocation) in
            print(l)
        } | { (e: Error) in
            print(e)
        }
        
    }
    
}
