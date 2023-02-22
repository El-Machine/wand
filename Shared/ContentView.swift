//
//  ContentView.swift
//  Shared
//
//  Created by Alex Kozin on 29.08.2022.
//

import CoreMotion

import Pipe
import SwiftUI

struct ContentView: View {

    var body: some View {
        Text("Hello, Pipe |").onAppear {


            |{ (data: CMPedometerData) in

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
