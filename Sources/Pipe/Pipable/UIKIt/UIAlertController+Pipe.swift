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

import UIKit.UIAlertController

extension UIAlertController: Constructable {

    static func | (piped: Any?, type: UIAlertController.Type) -> Self {
        let pipe = (piped as? Pipable)?.isPiped

        let style = piped as? UIAlertController.Style ?? pipe?.get() ?? .alert
        let title = piped as? String ?? pipe?.get()

        return Self(title: title,
                    message: pipe?.get(for: "UIAlertControllerMessage"),
                    preferredStyle: style)
    }

    @discardableResult
    public static func | (controller: UIAlertController,
                   action: (title: String, handler: ((UIAlertAction) -> Void)?))
    -> UIAlertController {
        controller | (action.title, .default, action.handler)
    }
    
    
    @discardableResult
    public static func | (controller: UIAlertController,
                   action: (title: String,
                            style: UIAlertAction.Style)
    ) -> UIAlertController {
        controller | (action.title, action.style, nil)
    }
    
    @discardableResult
    public static func | (controller: UIAlertController,
                   action: (title: String,
                            style: UIAlertAction.Style,
                            handler: ((UIAlertAction) -> Void)?)
    ) -> UIAlertController {

        let title = NSLocalizedString(action.title, comment: "")
        controller.addAction(UIAlertAction(title: title,
                                           style: action.style,
                                           handler: action.handler))
        
        return controller
    }
    
}

extension UIAlertController.Style: Pipable {
    
    static postfix func |(p: UIAlertController.Style) -> UIAlertController {
        p | UIAlertController.self
    }
    
}
