//
//  CoreAnimation+Extensions.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit

internal extension CALayer {
    func applyShadow(color: UIColor = UIColor(red: 83/255, green: 81/255, blue: 74/255, alpha: 1.0),
                     alpha: Float = 0.25,
                     x: CGFloat = 0,
                     y: CGFloat = 0,
                     blur: CGFloat = 20,
                     spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        masksToBounds =  false
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread / UIScreen.main.scale
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

internal extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

internal extension UIView {
    static func makeFromNib<T: UIView>(_ type: T.Type, owner: Any?) -> T {
        guard let view = Bundle(for: type).loadNibNamed(T.className, owner: owner, options: nil)?.first as? T else {
            fatalError("Nib named \(T.className) expects the root to be of type \(self)")
        }
        
        return view
    }
}

internal extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
