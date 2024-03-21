//
//  URL_Image_Pipe.swift
//  Energy
//
//  Created by Alex Kozin on 20.10.2022.
//  Copyright © 2022 El Machine. All rights reserved.
//

import Foundation
import UIKit.UIButton

//UIButton
@discardableResult
func | (path: String?, button: UIButton) -> Pipe {
    guard
        let path,
        !path.isEmpty
    else {
        button.setImage(nil, for: .normal)
        return Pipe()
    }

    return path | button
}

//@discardableResult
//func | (path: String, button: UIButton) -> Pipe {
//    URL(string: path)! | button
//}
//
//@discardableResult
//func | (url: URL?, button: UIButton) -> Pipe {
//    button.kf.setImage(with: url, for: .normal)
//    return Pipe()
//}
//
//UIImageView
//@discardableResult
//func | (path: String?, imageView: UIImageView) -> Pipe {
//    guard
//        let path,
//        !path.isEmpty
//    else {
//        imageView.image = nil
//        return Pipe()
//    }
//
//    return path | imageView
//}
//
//@discardableResult
//func | (path: String, imageView: UIImageView) -> Pipe {
//    URL(string: path)! | imageView
//}

//@discardableResult
//func | (url: URL?, imageView: UIImageView) -> Pipe {
//    imageView.kf.setImage(with: url)
//    return Pipe()
//}
