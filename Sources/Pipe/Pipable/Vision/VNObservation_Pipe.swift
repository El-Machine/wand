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
protocol VisionObservationExpectable: ExpectableWithout {

    associatedtype Request: VNRequest

}

extension VisionObservationExpectable {

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {

        let perform = { (handler: VNImageRequestHandler) in
            let request = piped as? Request ?? pipe.get()

            try! handler.perform([request])
            if let results = request.results {
                pipe.put(results as! [Self])
            }
        }

        //There is request handler already?
        if let handler = piped as? VNImageRequestHandler ?? pipe.get() {
            perform(handler)
        } else {
            //Otherwise wait for buffer
            pipe | { (buffer: CMSampleBuffer) in
                perform(buffer|)
            }
        }
    }

}
@available(iOS 14.0, *)
extension VNHumanHandPoseObservation: VisionObservationExpectable {

    typealias Request = VNDetectHumanHandPoseRequest

    static func | (piped: VNHumanHandPoseObservation,
                   joint: JointName) -> CGPoint {
        let recognized = try! piped.recognizedPoint(joint)
        return CGPoint(x: recognized.location.x, y: 1 - recognized.location.y)
    }

}

@available(iOS 14.0, *)
extension VNHumanBodyPoseObservation: VisionObservationExpectable {

    typealias Request = VNDetectHumanBodyPoseRequest

}

@available(iOS 14.0, *)
extension VNFaceObservation: VisionObservationExpectable {

    typealias Request = VNDetectFaceRectanglesRequest

}

@available(iOS 14.0, *)
extension VNClassificationObservation: VisionObservationExpectable {

    typealias Request = VNClassifyImageRequest

}
