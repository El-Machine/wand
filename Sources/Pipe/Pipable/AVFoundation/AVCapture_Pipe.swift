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

    public static func construct(in pipe: Pipe) -> Self {

        let deviceType: AVCaptureDevice.DeviceType = pipe.get()
                                                    ?? .builtInWideAngleCamera

        let mediaType: AVMediaType = pipe.get()
                                    ?? .video

        let position: AVCaptureDevice.Position = pipe.get()
                                                ?? .front

        let device = Self.default(deviceType,
                                  for: mediaType,
                                  position: position) as! Self

        return pipe.put(device)
    }

}

extension AVCaptureDeviceInput: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        let device: AVCaptureDevice = pipe.get()
        return pipe.put(try! Self(device: device))
    }

}

extension AVCaptureSession: Constructable {

    public static func construct(in pipe: Pipe) -> Self {
        pipe.put(Self())
    }

}

extension AVCaptureVideoDataOutput: Asking {

    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {

        guard pipe.ask(for: ask) else {
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
                                    ?? DispatchQueue(label: "Pipe_VideoDataOutput",
                                                     qos: .userInteractive)

            output.setSampleBufferDelegate(delegate, queue: queue)
        } else {
            pipe.put(Pipe.Error.vision("Could not add video data output"))
        }
        session.commitConfiguration()
        session.startRunning()

        pipe.put(output)
        ask.cleaner = {
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

    public static func construct(in pipe: Pipe) -> Self {
        let layer = Self()
        layer.videoGravity =    pipe.get() ?? .resizeAspectFill

        layer.session =         pipe.get()

        return pipe.put(layer)
    }

}

//CoreMedia_Pipe
import CoreMedia.CMSampleBuffer

extension CMSampleBuffer: Asking {

    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) where T : Asking {

        //AVCaptureVideoDataOutput will produce CMSampleBuffer
        pipe | Ask<AVCaptureVideoDataOutput>.every()
    }

}
