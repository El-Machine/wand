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

#if canImport(UIKit)
import UIKit.UIImage

public struct Barcode {

    public enum Generator: String {
        case code128 = "CICode128BarcodeGenerator"
        case pdf417 = "CIPDF417BarcodeGenerator"
        case aztec = "CIAztecCodeGenerator"
        case qr = "CIQRCodeGenerator"
    }

    public typealias Colors = (foreground: UIColor?, background: UIColor?)

}

public func |(piped: String?, type: Barcode.Generator) -> UIImage? {
    piped?.data(using: .ascii) | type
}

public func |(piped: String?, to: (type: Barcode.Generator,
                                   size: CGSize?,
                                   colors: Barcode.Colors?)) -> UIImage? {
    piped?.data(using: .ascii) | to
}

public func |(piped: Data?, type: Barcode.Generator) -> UIImage? {
    piped | (type: type, nil, nil)
}

public func |(piped: Data?, to: (type: Barcode.Generator,
                                 size: CGSize?,
                                 colors: Barcode.Colors?)) -> UIImage? {

    guard let filter = CIFilter(name: to.type.rawValue) else {
        return nil
    }
    filter.setValue(piped, forKey: "inputMessage")

    guard var ciImage = filter.outputImage else {
        return nil
    }

    if let colors = to.colors {
        ciImage = ciImage.applyingFilter("CIFalseColor", parameters: [
            "inputColor0": CIColor(color: colors.foreground ?? .black),
            "inputColor1": CIColor(color: colors.background ?? .white)
        ])
    }


    if let size = to.size {

        let imageSize = ciImage.extent.size

        let transform = CGAffineTransform(scaleX: size.width / imageSize.width,
                                          y: size.height / imageSize.height)
        ciImage = ciImage.transformed(by: transform)

    }

    return UIImage(ciImage: ciImage)
}

#endif
