//
//  UIGestureRecognizer.swift
//  Energy
//
//  Created by Alex Kozin on 03.11.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import UIKit.UIGestureRecognizer

extension UIGestureRecognizer: Pipable {

}


@discardableResult
public
func |<T: UIGestureRecognizer> (view: UIView, handler: @escaping (T)->()) -> T {
    view | .every(handler: handler)
}

@discardableResult
public
func |<T: UIGestureRecognizer> (view: UIView, ask: Ask<T>) -> T {

    typealias Delegate = UIGestureRecognizer.Delegate

    let pipe = Pipe()


    let recognizer = T()

    ask.key = recognizer.address|
    _ = pipe.ask(for: ask)


    let delegate = pipe.put(Delegate())
    recognizer.addTarget(delegate,
                         action: #selector(Delegate.handle(sender:)))

    view.addGestureRecognizer(recognizer)

    return pipe.put(recognizer)
}

extension UIGestureRecognizer {

    class Delegate: NSObject, Pipable {

        @objc
        func handle(sender: UIGestureRecognizer) {
            isPiped?.put(sender, key: sender.address|)
        }

    }

}
