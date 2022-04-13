//  Copyright © 2020-2022 Alex Kozin
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
//  2022 Alex Kozin
//

import UIKit.UIImage

extension UIImage: Expectable {
    
    static func expect<T>(_ event: Event<T>, from: Pipable) -> Starter {
        (nil, {
            let pipe = event.pipe
            let picker = from as? UIImagePickerController ?? pipe.get()

            let sheet = UIAlertController.Style.actionSheet|

            func show(source: UIImagePickerController.SourceType) {
                picker.sourceType = source
                picker.presentOnVisible()
            }

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                sheet | ("UIImagePickerController.TakePhoto", { _ in
                    show(source: .camera)
                })
            }
            sheet | ("UIImagePickerController.ChoosePhoto", { _ in
                show(source: .photoLibrary)
            })
            sheet | ("UIImagePickerController.Cancel", .cancel)

            sheet.presentOnVisible()
        })
    }
    
}

extension UIImage {
    
    static func | (image: UIImage, renderingMode: RenderingMode) -> UIImage {
        image.withRenderingMode(renderingMode)
    }
    
    static postfix func | (image: UIImage) -> UIImageView {
        UIImageView(image: image)
    }
    
    static func | (image: UIImage, renderingMode: RenderingMode) -> UIImageView {
        (image | renderingMode)|
    }
    
    
    enum Operations {
        case rounded(CGFloat)
    }
    
    static func | (image: UIImage, operation: Operations) -> UIImage {
        switch operation {
            case .rounded(let radius):
                return UIGraphicsImageRenderer(size: image.size).image { c in
                    let rect: CGRect = image.size|
                    UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
                    image.draw(in: rect)
                }
        }
    }
    
    func resize(withSize size: CGSize, contentMode: UIView.ContentMode = .scaleAspectFill) -> UIImage? {
            let aspectWidth = size.width / self.size.width
            let aspectHeight = size.height / self.size.height
            
            switch contentMode {
            case .scaleToFill:
                return resize(withSize: size)
            case .scaleAspectFit:
                let aspectRatio = min(aspectWidth, aspectHeight)
                return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
            case .scaleAspectFill:
                let aspectRatio = max(aspectWidth, aspectHeight)
                return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
                default:
                    fatalError()
            }
        }
        
        private func resize(withSize size: CGSize) -> UIImage? {
            UIGraphicsImageRenderer(size: size).image { c in
                draw(in: size|)
            }
        }
    
}
