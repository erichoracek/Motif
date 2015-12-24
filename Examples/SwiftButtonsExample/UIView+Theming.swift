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
            applierBlock: { (color, view) -> Void in
                guard let view = view as? UIView else { return }
                guard let color = color as? UIColor else { return }

                view.backgroundColor = color
            })
        
        self.mtf_registerThemeProperty(
            ThemeProperties.borderColor.rawValue,
            requiringValueOfClass: UIColor.self,
            applierBlock: { (color, view) -> Void in
                guard let view = view as? UIView else { return }
                guard let color = color as? UIColor else { return }

                view.layer.borderColor = color.CGColor
            })
        
        self.mtf_registerThemeProperty(
            ThemeProperties.cornerRadius.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (cornerRadius, view) -> Void in
                guard let view = view as? UIView else { return }
                guard let cornerRadius = cornerRadius as? NSNumber else { return }

                view.layer.cornerRadius = CGFloat(cornerRadius.floatValue)
            })
        
        self.mtf_registerThemeProperty(
            ThemeProperties.borderWidth.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (borderWidth, view) -> Void in
                guard let view = view as? UIView else { return }
                guard let borderWidth = borderWidth as? NSNumber else { return }

                view.layer.borderWidth = CGFloat(borderWidth.floatValue)
            })
    }
}
