//
//  File.swift
//  
//
//  Created by Alex Kozin on 24.02.2021.
//

#if canImport(UIKit)

//IndexPath
extension Array {
    
    static postfix func |(p: Self) -> [IndexPath] {
        (0..<p.count)|
    }
}

extension Range where Bound == Int {

    static postfix func |(p: Self) -> [IndexPath] {
        p.map {
            IndexPath(row: $0, section: 0)
        }
    }

}

//Int
extension Int {
    
    static postfix func |(p: Self) -> [IndexPath] {
        [p|]
    }
    
    static postfix func |(p: Self) -> IndexPath {
        IndexPath(row: p, section: 0)
    }
    
}

//UIEdgeInsets
postfix func |(p: (CGFloat, CGFloat, CGFloat, CGFloat)) -> UIEdgeInsets {
    UIEdgeInsets(top: p.0, left: p.1, bottom: p.2, right: p.3)
}

//UIView
postfix func |(p: (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)) -> UIView {
    UIView(frame: CGRect(x: p.0, y: p.1, width: p.2, height: p.3))
}

extension CGRect {
    
    static postfix func |(p: Self) -> UIView {
        UIView(frame: p)
    }
    
}
#endif
