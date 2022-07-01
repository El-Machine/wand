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

@available(iOS 14.0, *)
extension VNHumanHandPoseObservation: VisionObservationAsking {

    typealias Request = VNDetectHumanHandPoseRequest

    static func | (piped: VNHumanHandPoseObservation,
                   joint: JointName) -> CGPoint {
        let recognized = try! piped.recognizedPoint(joint)
        return CGPoint(x: recognized.location.x, y: 1 - recognized.location.y)
    }

}

@available(iOS 14.0, *)
extension VNHumanBodyPoseObservation: VisionObservationAsking {

    typealias Request = VNDetectHumanBodyPoseRequest

}

@available(iOS 14.0, *)
extension VNFaceObservation: VisionObservationAsking {

    typealias Request = VNDetectFaceRectanglesRequest

}

@available(iOS 14.0, *)
extension VNClassificationObservation: VisionObservationAsking {

    typealias Request = VNClassifyImageRequest

}

//Asking
protocol VisionObservationAsking: Asking {

    associatedtype Request: VNRequest

}

extension VisionObservationAsking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {

        let perform = { (handler: VNImageRequestHandler) in
            let request = with as? Request ?? pipe.get()

            try! handler.perform([request])
            if let results = request.results {
                pipe.put(results as! [Self])
            }
        }

        //There is request handler already?
        if let handler = with as? VNImageRequestHandler ?? pipe.get() {
            perform(handler)
        } else {
            //Otherwise wait for buffer
            pipe | { (buffer: CMSampleBuffer) in
                perform(buffer|)
            }
        }
    }

}
