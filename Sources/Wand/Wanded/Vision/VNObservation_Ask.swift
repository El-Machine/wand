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

#if canImport(Vision)
import Vision

import CoreMedia.CMSampleBuffer
import Vision.VNObservation

/// Ask
///
/// |{ (hands: [VNHumanHandPoseObservation]) in
///
/// }
///
/// URL(string: "http://example.com/image.jpg") | { (faces: [VNFaceObservation]) in
///
/// }
///
/// data | .while { (bodies: [VNHumanBodyPoseObservation]) in
///     bodies < 2
/// }
///
public
protocol VisionObservationAsking: Asking, Wanded {

    associatedtype Request: VNRequest

}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
public
extension VisionObservationAsking {

    static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        guard wand.answer(the: ask) else {
            return
        }

        let perform = { (handler: VNImageRequestHandler) in
            let request: Request = wand.obtain()

            try! handler.perform([request])
            if let results = request.results, !results.isEmpty {
                wand.add(results as! [Self])
            } else {
                wand.close()
            }
        }

        //There is request handler already?
        if let handler: VNImageRequestHandler = wand.get() {
            perform(handler)
        } else {
            //Otherwise wait for buffer
            
            if #available(tvOS 17.0, *) {

                wand | { (buffer: CMSampleBuffer) in

                    let request = VNImageRequestHandler(cmSampleBuffer: buffer)
                    perform(request)
                }

            } else {
                //TODO: Fallback on earlier versions
            }
        }
    }

}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension VNFaceObservation: VisionObservationAsking {

    public
    typealias Request = VNDetectFaceRectanglesRequest

}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension VNBarcodeObservation: VisionObservationAsking {

    public
    typealias Request = VNDetectBarcodesRequest

}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension VNHumanHandPoseObservation: VisionObservationAsking {

    public
    typealias Request = VNDetectHumanHandPoseRequest

    static func | (piped: VNHumanHandPoseObservation,
                   joint: JointName) -> CGPoint {
        let recognized = try! piped.recognizedPoint(joint)
        return CGPoint(x: recognized.location.x, y: 1 - recognized.location.y)
    }

}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension VNHumanBodyPoseObservation: VisionObservationAsking {

    public
    typealias Request = VNDetectHumanBodyPoseRequest

}

@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
extension VNClassificationObservation: VisionObservationAsking {

    public
    typealias Request = VNClassifyImageRequest

}

#endif
