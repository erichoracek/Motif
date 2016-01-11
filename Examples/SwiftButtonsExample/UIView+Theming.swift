//
//  UIView+Theming.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit
import Motif

extension UIView {
    public override class func initialize() {
        guard self === UIView.self else { return }
        
        self.mtf_registerThemeProperty(
            ThemeProperties.backgroundColor.rawValue,
            requiringValueOfClass: UIColor.self,
            applierBlock: { (color, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let color = color as? UIColor else { return false }

                view.backgroundColor = color

                return true
            })
        
        self.mtf_registerThemeProperty(
            ThemeProperties.borderColor.rawValue,
            requiringValueOfClass: UIColor.self,
            applierBlock: { (color, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let color = color as? UIColor else { return false }

                view.layer.borderColor = color.CGColor

                return true
            })
        
        self.mtf_registerThemeProperty(
            ThemeProperties.cornerRadius.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (cornerRadius, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let cornerRadius = cornerRadius as? NSNumber else { return false }

                view.layer.cornerRadius = CGFloat(cornerRadius.floatValue)

                return true
            })
        
        self.mtf_registerThemeProperty(
            ThemeProperties.borderWidth.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (borderWidth, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let borderWidth = borderWidth as? NSNumber else { return false }

                view.layer.borderWidth = CGFloat(borderWidth.floatValue)

                return true
            })
    }
}
