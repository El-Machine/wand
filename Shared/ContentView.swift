//
//  ContentView.swift
//  Shared
//
//  Created by Alex Kozin on 29.08.2022.
//

import CoreBluetooth
import CoreLocation

import SwiftUI
import Pipe

struct ContentView: View {

    var body: some View {
        Text("Hello, Pipe |").onAppear {



//            |
//                .retrieve { (peripherals: [CBPeripheral]) in
//                    print()
//                }

            let uids: [CBUUID] = [.flipperZerof6,
                                  .flipperZeroWhite,
                                  .flipperZeroBlack]

            let pipe = Pipeline()
            pipe.store(uids)

            pipe | { (peripheral: CBPeripheral) in
                print(peripheral.name)
            }


        }

    }

    func codes() {

    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
