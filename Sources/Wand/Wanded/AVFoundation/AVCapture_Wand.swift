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

#if !os(watchOS)

@available(tvOS 17.0, *)
@available(visionOS, unavailable)
extension AVCaptureDevice: Obtain {

    public static func obtain(by wand: Wand?) -> Self {

        let deviceType: AVCaptureDevice.DeviceType = wand?.get()
                                                    ?? .builtInWideAngleCamera

        let mediaType: AVMediaType = wand?.get()
                                    ?? .video

        let position: AVCaptureDevice.Position = wand?.get()
                                                ?? .front

        let device = Self.default(deviceType,
                                  for: mediaType,
                                  position: position) as! Self

        return wand?.add(device) ?? device
    }

}

@available(tvOS 17.0, *)
@available(visionOS, unavailable)
extension AVCaptureDeviceInput: Obtain {

    public static func obtain(by wand: Wand?) -> Self {
        
        guard let wand else {
            fatalError()
        }

        let device: AVCaptureDevice = wand.obtain()
        return wand.add(try! Self(device: device))
    }

}

@available(tvOS 17.0, *)
extension AVCaptureSession: Obtain {

    public static func obtain(by wand: Wand?) -> Self {
        wand?.add(Self()) ?? Self()
    }

}

@available(tvOS 17.0, *)
@available(visionOS, unavailable)
extension AVCaptureVideoDataOutput: Asking, Wanded {

    public static func wand<T>(_ wand: Wand, asks ask: Ask<T>) {

        guard wand.answer(the: ask) else {
            return
        }

        let session: AVCaptureSession = wand.obtain()
        session.beginConfiguration()

        let preset: AVCaptureSession.Preset = wand.get() ?? .high
        session.sessionPreset = preset

        if session.inputs.isEmpty {
            let deviceInput: AVCaptureDeviceInput = wand.obtain()
            session.addInput(deviceInput)
        }

        let output = Self()
        if session.canAddOutput(output) {
            session.addOutput(output)

            let discards: Bool = wand.get(for: "alwaysDiscardsLateVideoFrames") ?? true
            output.alwaysDiscardsLateVideoFrames = discards

            let settings: [String: Any] = wand.get()
            ?? [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            output.videoSettings = settings

            let delegate = wand.add(Delegate())
            let queue: DispatchQueue = wand.get()
                                    ?? DispatchQueue(label: "Pipe_VideoDataOutput",
                                                     qos: .userInteractive)

            output.setSampleBufferDelegate(delegate, queue: queue)
        } else {
            wand.add(Wand.Error.vision("Could not add video data output"))
        }
        session.commitConfiguration()
        session.startRunning()

        wand.add(output)

        wand.setCleaner(for: ask) {
            session.stopRunning()
        }
    }


}

@available(watchOS 6, tvOS 17.0, *)
extension AVCaptureVideoDataOutput {

    class Delegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, Wanded {

        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
            isWanded?.add(sampleBuffer)
        }

    }

}

@available(tvOS 17.0, *)
@available(visionOS, unavailable)
extension AVCaptureVideoPreviewLayer: Obtain {

    public static func obtain(by wand: Wand?) -> Self {
        let layer = Self()
        layer.videoGravity =    wand?.get() ?? .resizeAspectFill
        layer.session =         wand!.obtain()

        return wand?.add(layer) ?? layer
    }

}

#endif
