//
//  UIGestureRecognizer.swift
//  Energy
//
//  Created by Alex Kozin on 03.11.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import UIKit.UIGestureRecognizer

extension UILongPressGestureRecognizer: Asking {
    
    public static func ask<T>(_ ask: Ask<T>, from pipe: Pipe) {

        _ = pipe.ask(for: ask)

        let delegate = pipe.get(or: Delegate())

        let recognizer: Self = pipe.get() ?? Self()
        recognizer.addTarget(delegate,
                             action: #selector(Delegate.handleLongPress(sender:)))


        let view: UIView = pipe.get()!
        view.addGestureRecognizer(recognizer)

    }


}

extension UIGestureRecognizer {

    class Delegate: NSObject, Pipable {

        @objc
        func handleLongPress(sender: UILongPressGestureRecognizer) {
            isPiped?.put(sender)
        }

    }

}
