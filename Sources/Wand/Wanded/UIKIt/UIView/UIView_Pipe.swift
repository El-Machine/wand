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
import UIKit

//UIView
public
postfix func |(view: UIView) -> CGSize {
    view.frame.size
}

public
func | (view: UIView, contentMode: UIView.ContentMode) -> UIView {
    view.contentMode = contentMode
    return view
}

public
postfix func |(rect: CGRect) -> UIView {
    UIView(frame: rect)
}

//Animations
public
func |(interval: TimeInterval, animations: @escaping ()->()) {
    UIView.animate(withDuration: interval, animations: animations)
}

public
func |(piped: (duration: TimeInterval, delay: TimeInterval),
       animations: @escaping ()->()) {

    UIView.animate(withDuration: piped.duration,
                   delay: piped.delay,
                   options: [],
                   animations: animations)
}

public
func |(piped: (duration: TimeInterval, options: UIView.AnimationOptions),
              animations: @escaping ()->() ) {
    UIView.animate(withDuration: piped.duration,
                   delay: 0,
                   options: piped.options,
                   animations: animations)
}

public func |(piped: (duration: TimeInterval,
                      options: UIView.AnimationOptions),
                blocks: (animations: ()->(),
                         completion: (Bool)->())
) {
    UIView.animate(withDuration: piped.duration,
                   delay: 0,
                   options: piped.options,
                   animations: blocks.animations,
                   completion: blocks.completion)
}

#endif
