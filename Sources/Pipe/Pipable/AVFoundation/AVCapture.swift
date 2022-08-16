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

import AVFoundation

extension AVCaptureDevice: Constructor {

    static func | (piped: Any?, type: AVCaptureDevice.Type) -> Self {
        let pipe = piped.pipe

        let deviceType = piped as? AVCaptureDevice.DeviceType ?? pipe.get()
        ?? .builtInWideAngleCamera

        let mediaType = piped as? AVMediaType ?? pipe.get()
        ?? .video

        let position = piped as? AVCaptureDevice.Position ?? pipe.get()
        ?? .front

        let device = Self.default(deviceType,
                                  for: mediaType,
                                  position: position) as! Self
        return pipe.put(device)
    }

}

extension AVCaptureDeviceInput: Constructor {

    static func | (piped: Any?, type: AVCaptureDeviceInput.Type) -> Self {
        let pipe = piped.pipe

        let device = piped as? AVCaptureDevice ?? pipe.get()

        let input = try! Self(device: device)
        return pipe.put(input)
    }

}

extension AVCaptureSession: Constructor {

    static func | (piped: Any?, type: AVCaptureSession.Type) -> Self {
        piped.pipe.put(Self())
    }

}

extension AVCaptureVideoDataOutput: Expectable, Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        let session = with as? AVCaptureSession ?? pipe.get()
        session.beginConfiguration()

        let preset = with as? AVCaptureSession.Preset ?? pipe.get() ?? .high
        session.sessionPreset = preset

        if session.inputs.isEmpty {
            let deviceInput = with as? AVCaptureDeviceInput ?? pipe.get()
            session.addInput(deviceInput)
        }

        let output = Self()
        if session.canAddOutput(output) {
            session.addOutput(output)

            let discards: Bool = pipe.get(for: "alwaysDiscardsLateVideoFrames") ?? true
            output.alwaysDiscardsLateVideoFrames = discards

            let settings: [String: Any] = pipe.get()
            ?? [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            output.videoSettings = settings

            let delegate = pipe.put(Delegate())
            let queue = with as? DispatchQueue ?? pipe.get()
            ?? DispatchQueue(label: "Pipe_VideoDataOutput", qos: .userInteractive)
            output.setSampleBufferDelegate(delegate, queue: queue)
        } else {
            pipe.put(Err.vision("Could not add video data output"))
        }
        session.commitConfiguration()
        session.startRunning()

        pipe.put(output)
        expect.cleaner = {
            session.stopRunning()
        }
    }


}

extension AVCaptureVideoDataOutput {

    class Delegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, Pipable {

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            isPiped?.put(sampleBuffer)
        }

    }

}

extension AVCaptureVideoPreviewLayer: Constructor {

    static func | (piped: Any?, type: AVCaptureVideoPreviewLayer.Type) -> Self {
        let pipe = piped.pipe

        let layer = Self()
        layer.videoGravity = piped as? AVLayerVideoGravity ?? pipe.get() ?? .resizeAspectFill
        layer.session = piped as? AVCaptureSession ?? pipe.get()
        return piped.pipe.put(layer)
    }



}

//CoreMedia_Pipe
import CoreMedia.CMSampleBuffer

extension CMSampleBuffer: Asking {

    static func ask<E>(with: Any?, in pipe: Pipe, expect: Expect<E>) {
        //AVCaptureVideoDataOutput will produce CMSampleBuffer
        pipe | AVCaptureVideoDataOutput.every
    }


}
