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
import Vision.VNRequest

import CoreGraphics.CGImage
import CoreImage.CIImage

extension VNImageRequestHandler: Obtain {

    public static func obtain(by wand: Wand?) -> Self {

        guard let wand else {
            fatalError()
        }

        let orientation: CGImagePropertyOrientation = wand.get() ?? .up
        let options: [VNImageOption : Any] = wand.get() ?? [:]

        let request: Self
        if let buffer: CMSampleBuffer = wand.get() {
            if #available(iOS 14.0, macOS 11.0, tvOS 14, *) {
                request = Self(cmSampleBuffer: buffer,
                               orientation: orientation,
                               options: options)
            } else {
                fatalError()
            }

            return wand.add(request)
        }

        if let pixelBuffer: CVPixelBuffer = wand.get() {
            if #available(iOS 14.0, macOS 11.0, *) {
                request = Self(cvPixelBuffer: pixelBuffer,
                               orientation: orientation,
                               options: options)
            } else {
                fatalError()
            }

            return wand.add(request)
        }

        if let image: CGImage = wand.get() {
            request = Self(cgImage: image,
                           orientation: orientation,
                           options: options)

            return wand.add(request)
        }


        if let image: CIImage = wand.get() {
            request = Self(ciImage: image,
                           orientation: orientation,
                           options: options)

            return wand.add(request)
        }


        if let data: Data = wand.get() {
            request = Self(data: data,
                           orientation: orientation,
                           options: options)

            return wand.add(request)
        }

        if let url: URL = wand.get() {
            request = Self(url: url,
                           orientation: orientation,
                           options: options)

            return wand.add(request)
        }


        fatalError( """
                    🔥 It's yet not possible to construct
                    \(self)
                    """)
    }

}

#endif
