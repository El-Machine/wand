//  Copyright © 2020-2022 El Machine 🤖
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Alex Kozin
//

import CoreMedia.CMSampleBuffer
import Vision.VNObservation

/// Pipe.Expectable
///
/// prefix |<E: VNObservation> (handler: (E)->() )
///
/// #Usage
/// ```
///
///   |{ (hands: [VNHumanHandPoseObservation]) in
///
///   }
///
///   URL(string: "http://example.com/image.jpg") | { (faces: [VNFaceObservation]) in
///
///   }
///
///   data | .while { (bodies: [VNHumanBodyPoseObservation]) in
///     bodies < 2
///   }
/// ```
///
public
protocol VisionObservationExpectable: Asking {

    associatedtype Request: VNRequest

}

public
extension VisionObservationExpectable {

    static func ask<T: Asking>(_ ask: Ask<T>, from pipe: Pipe) {

        guard pipe.ask(for: ask) else {
            return
        }

        let perform = { (handler: VNImageRequestHandler) in
            let request: Request = pipe.get()

            try! handler.perform([request])
            if let results = request.results, !results.isEmpty {
                pipe.put(results as! [Self])
            } else {
                pipe.close()
            }
        }

        //There is request handler already?
        if let handler: VNImageRequestHandler = pipe.get() {
            perform(handler)
        } else {
            //Otherwise wait for buffer
            pipe | { (buffer: CMSampleBuffer) in

                let request = VNImageRequestHandler(cmSampleBuffer: buffer)
                perform(request)
            }
        }
    }

}

@available(iOS 14.0, *)
extension VNFaceObservation: VisionObservationExpectable {

    public
    typealias Request = VNDetectFaceRectanglesRequest

}

@available(iOS 14.0, *)
extension VNBarcodeObservation: VisionObservationExpectable {

    public
    typealias Request = VNDetectBarcodesRequest

}

@available(iOS 14.0, macOS 11.0, *)
extension VNHumanHandPoseObservation: VisionObservationExpectable {

    public
    typealias Request = VNDetectHumanHandPoseRequest

    static func | (piped: VNHumanHandPoseObservation,
                   joint: JointName) -> CGPoint {
        let recognized = try! piped.recognizedPoint(joint)
        return CGPoint(x: recognized.location.x, y: 1 - recognized.location.y)
    }

}

@available(iOS 14.0, macOS 11.0, *)
extension VNHumanBodyPoseObservation: VisionObservationExpectable {

    public
    typealias Request = VNDetectHumanBodyPoseRequest

}

@available(iOS 14.0, *)
extension VNClassificationObservation: VisionObservationExpectable {

    public
    typealias Request = VNClassifyImageRequest

}
