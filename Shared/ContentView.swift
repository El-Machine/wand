//
//  ContentView.swift
//  Shared
//
//  Created by Alex Kozin on 29.08.2022.
//

import CoreBluetooth
import CoreLocation

import SwiftUI
import Wand

struct ContentView: View {

    var body: some View {

        Text("Hello, Wand |").onAppear {

            let wand = |.every { (l: CLLocation) in

                print(l)
            } | { (e: Error) in
                print(e)

            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                wand.close()
            }



//            |
//                .retrieve { (peripherals: [CBPeripheral]) in
//                    print()
//                }

//            let uids: [CBUUID] = [.flipperZerof6,
//                                  .flipperZeroWhite,
//                                  .flipperZeroBlack]
//
//            let pipe = Wand()
//            pipe.store(uids)
//
//            pipe | { (peripheral: CBPeripheral) in
//                print(peripheral.name)
//            }


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
