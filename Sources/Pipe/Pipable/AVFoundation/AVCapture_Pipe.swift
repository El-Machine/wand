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

extension AVCaptureDevice: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {

        let deviceType = piped as? AVCaptureDevice.DeviceType
                                    ?? pipe.get()
                                    ?? .builtInWideAngleCamera

        let mediaType = piped as? AVMediaType
                                ?? pipe.get()
                                ?? .video

        let position = piped as? AVCaptureDevice.Position
                                ?? pipe.get()
                                ?? .front

        return Self.default(deviceType,
                        for: mediaType,
                        position: position) as! Self
    }

}

extension AVCaptureDeviceInput: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {
        let device = piped as? AVCaptureDevice ?? pipe.get()
        return try! Self(device: device)
    }

}

extension AVCaptureSession: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {
        Self()
    }

}

extension AVCaptureVideoDataOutput: ExpectableWithout {

    public static func expect<E>(_ expectation: Expect<E>, from pipe: Pipe) {

        guard pipe.expect(expectation) else {
            return
        }

        let session: AVCaptureSession = pipe.get()
        session.beginConfiguration()

        let preset: AVCaptureSession.Preset = pipe.get() ?? .high
        session.sessionPreset = preset

        if session.inputs.isEmpty {
            let deviceInput: AVCaptureDeviceInput = pipe.get()
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
            let queue: DispatchQueue = pipe.get()
            ?? DispatchQueue(label: "Pipe_VideoDataOutput", qos: .userInteractive)
            output.setSampleBufferDelegate(delegate, queue: queue)
        } else {
            pipe.put(Pipe.Error.vision("Could not add video data output"))
        }
        session.commitConfiguration()
        session.startRunning()

        pipe.put(output)
        expectation.cleaner = {
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

extension AVCaptureVideoPreviewLayer: Constructable {

    public static func construct<P>(with piped: P, on pipe: Pipe) -> Self {
        let layer = Self()
        layer.videoGravity = piped as? AVLayerVideoGravity ?? pipe.get() ?? .resizeAspectFill
        layer.session = piped as? AVCaptureSession ?? pipe.get()
        return pipe.put(layer)
    }

}

//CoreMedia_Pipe
import CoreMedia.CMSampleBuffer

extension CMSampleBuffer: Expectable {

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) {
        //AVCaptureVideoDataOutput will produce CMSampleBuffer
        pipe | AVCaptureVideoDataOutput.every
    }

}
