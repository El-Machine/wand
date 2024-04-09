/// Copyright © 2020-2024 El Machine 🤖 (http://el-machine.com/)
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
///
/// Created by Alex Kozin
///

import AVFoundation
import Contacts
import CoreBluetooth
import CoreLocation
import Vision

import SwiftUI
import Wand

struct ContentView: View {

    var preview: AVCaptureVideoPreviewLayer?

    var body: some View {

        Text("Hello, Wand |").onAppear {

//            [[CNContactFamilyNameKey as CNKeyDescriptor]] | .while { (l: CLLocation, i: Int) in
//
//                print("1. \(l)")
//
//                print("1. 🎲 \(i)")
//
//                return i != 4
//            } //|
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
//            .while { (c: CNContact) in
//
//                print("5. \(c)")
//                return c.familyName != "Higgins"
//
//            } | 
//            .all {
//                print("Last")
//            } | .any {
//                print("Any \($0)")
//            }

//            |.one { (f: VNFaceObservation) in
//
//                print("6. \(f)")
//
//            } //|

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

//            let wand = |{ (observations: [VNHumanBodyPoseObservation]) in
//
//                observations.forEach {
//                    print(try! $0.recognizedPoint(.leftWrist))
//                }
//            }

            //        let pipe = |{ (observations: [VNHumanHandPoseObservation]) in
            //
            //            DispatchQueue.main.sync {
            //                self.viewT.forEach{
            //                    $0.removeFromSuperview()
            //                }
            //                self.viewT.removeAll()
            //            }
            //
            //            observations.forEach {
            //
            //                let point = $0 | .wrist
            //                guard let converted = preview?.layerPointConverted(fromCaptureDevicePoint: point) else {
            //                    return
            //                }
            //
            //
            //                DispatchQueue.main.sync {
            //
            //                    let view = UIView(frame: (0,0,20,20)|)
            //                    view.center = converted
            //                    view.backgroundColor = .red
            //
            //
            //                    UIApplication.shared.visibleViewController?.view.addSubview(view)
            //
            //                    self.viewT.append(view)
            //                }
            //            }
            //        }

//            let request: VNDetectHumanHandPoseRequest = wand.obtain()
//            request.maximumHandCount = 2

//            let preview = wand.obtain() as AVCaptureVideoPreviewLayer
//            preview.frame = UIScreen.main.bounds
//
//            UIApplication.shared.visibleViewController?.view.layer.addSublayer(preview)


        }

    }

}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }

}
