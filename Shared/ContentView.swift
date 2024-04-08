//
//  ContentView.swift
//  Shared
//
//  Created by Alex Kozin on 29.08.2022.
//

import Contacts
import CoreBluetooth
import CoreLocation

import SwiftUI
import Wand

struct ContentView: View {

    var body: some View {

        Text("Hello, Wand |").onAppear {

            [[CNContactFamilyNameKey as CNKeyDescriptor]] | .while { (l: CLLocation, i: Int) in

                print("1. \(l)")

                print("1. 🎲 \(i)")

                return i != 4
            } | 
//            { (l: CLLocation) in
//
//                print("2. \(l)")
//
//            } | 
//            { (s: CLAuthorizationStatus) in
//
//                print("3. \(s)")
//
//            } | 
//            .one { (c: CLLocation) in
//
//                print("4. \(c)")
//
//            } //|
            .while { (c: CNContact) in

                print("5. \(c)")
                return c.familyName != "Higgins"

            } | .all {
                print("Last")
            }

            //|
//            { (e: Error) in
//                print(e)
//
//            }

//            CLAuthorizationStatus.authorizedWhenInUse | .one { (s: CLAuthorizationStatus) in
//
//                print(s)
//            } | { (e: Error) in
//                print(e)
//
//            }



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

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
