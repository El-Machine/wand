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

#if canImport(CoreNFC)
import CoreNFC
#endif

import Vision

import SwiftUI
import Wand

struct ContentView: View {

    var preview: AVCaptureVideoPreviewLayer?

    var body: some View {

        let urlString = "https://en.wikipedia.org/wiki/Laozi"

        Text("Hello, Wand |").onAppear {

//            //1. While location
//            [[CNContactFamilyNameKey as CNKeyDescriptor]] | .while { (l: CLLocation, i: Int) in
//
//                print("1. \(l)")
//
//                print("1. 🎲 \(i)")
//
//                return i != 4
//            } |
//
//            //2. Every location
//            { (l: CLLocation) in
//
//                print("2. \(l)")
//
//            } |
//
//            //3. One location
//            .one { (c: CLLocation) in
//
//                print("3. \(c)")
//
//            } |
//
//            //4.1 One status
//            { (s: CLAuthorizationStatus) in
//
//                print("4.1 \(s)")
//
//            } |
//
//            //4.2 Request authorizedAlways
//            CLAuthorizationStatus.authorizedAlways | .one { (s: CLAuthorizationStatus) in
//
//                print("4.2 \(s)")
//
//            } |
//
//            //5. Find contact
//            .while { (c: CNContact) in
//
//                print("5️⃣ \(c)")
//                return c.familyName != "Higgins"
//
//            } |
//
//            //7. One face
//            |.one { (f: VNFaceObservation) in
//
//                print("7️⃣ \(f)")
//
//            } |

//            |.one { (message: NFCNDEFMessage) in    //6️⃣ NFC read
//
//                print("|6️⃣ \(message)")
//
//            } |

            |Ask<NFCNDEFTag>.one().write(urlString|) { tag in
                
                print(tag)

            } |
//
//            .any {                                  //.. Notify
//                print("|📦 Did add \($0)")
//            } |
//
//            .all {                                  //.. Completion
//                print("Last")
//            } |
//
            { (e: Error) in                         //.. Error handling
                print(e)

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
