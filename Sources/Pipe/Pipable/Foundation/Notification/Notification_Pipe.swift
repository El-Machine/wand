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

import Foundation.NSNotification

/**Pipable

 infix | (name: Notification.Name, handler: (Notification)->() ) -> Pipe

 #Usage
 ```
 UIApplication.didBecomeActiveNotification | { (n: Notification) in

 }
 ```

 */

extension Notification: Asking {

    public
    static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) {

        let name: Notification.Name = pipe.get()!
        let key = name.rawValue

        ask.key = key

        guard pipe.ask(for: ask) else {
            return
        }

        let center: NotificationCenter = pipe.get()

        let token = center.addObserver(forName: name,
                                       object: nil,
                                       queue: nil) { notification in
            pipe.put(notification, key: key)
        }

        ask.cleaner = {
            center.removeObserver(token)
        }

    }

}
