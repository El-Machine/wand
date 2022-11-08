//
//  UIGestureRecognizer.swift
//  Energy
//
//  Created by Alex Kozin on 03.11.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import UIKit.UIGestureRecognizer

extension UILongPressGestureRecognizer: ExpectableWith {
    
    public typealias With = UIView

    public static func start<P, E>(expectating expectation: Expect<E>, with piped: P, on pipe: Pipe) where E : Expectable {

        _ = pipe.start(expecting: expectation)

        let delegate = pipe.get(or: Delegate())

        let recognizer: Self = pipe.get() ?? Self()
        recognizer.addTarget(delegate, action: #selector(Delegate.handleLongPress(sender:)))

        //        if recognizer.isPiped() {

        let view = piped as! UIView
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
