//
//  UIEvent_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 12.07.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

#if canImport(UIKit)
import UIKit

//extension UIEvent.EventSubtype: Pipable {
//
//}
//
//@available(iOS 13.0, *)
//prefix func | (motion: @escaping (UIEvent.EventSubtype)->()) {
//    //Looking for the key
//    if let key = UIWindow.key {
//        key | motion
//        return
//    }
//
//    |.one(UIWindow.didBecomeKeyNotification) { (notification: Notification) in
//        if let key = notification.object as? UIWindow {
//            key | motion
//        }
//    }
//}
//
//
//extension UIWindow: Pipable {
//
//    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        guard let pipe = isPiped else {
//            return
//        }
//
//        if let event = event {
//            pipe.put(event)
//        }
//
//        pipe.put(motion)
//    }
//
//    @available(iOS 13.0, *)
//    internal static var key: UIWindow? {
//        let windowScene = UIApplication.shared.connectedScenes.first {
//            ($0 as? UIWindowScene)?.activationState == .foregroundActive
//        } as? UIWindowScene
//        return windowScene?.windows.first(where: \.isKeyWindow)
//    }
//
//}
#endif
