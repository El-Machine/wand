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
import CoreServices.UTCoreTypes
import UIKit.UIImagePickerController
import UniformTypeIdentifiers

extension UIImagePickerController: Constructable {

    public static func construct(in pipe: Pipe) -> Self {

        let delegate = pipe.put(Delegate())
        
        let picker = pipe.put(Self())
        picker.allowsEditing = false
        picker.delegate = delegate

        let type: String
        if #available(iOS 14.0, *) {
            type = pipe.get() ?? UTType.image.identifier
        } else {
            type = pipe.get() ?? "kUTTypeImage"//kUTTypeImage as String
        }
        picker.mediaTypes = [type]

        return pipe.put(picker)
    }
    
}

extension UIImagePickerController {
    
    class Delegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Pipable {
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            picker.dismiss(animated: true)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            isPiped?.put(image)
        }
        
    }
    
}
#endif
