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
        self.mtf_registerThemeProperty(
            ThemeProperties.backgroundColor.rawValue,
            valueTransformerName: MTFColorFromStringTransformerName,
            applierBlock: { (color, view) -> Void in
                if
                    let view = view as? UIView,
                    let color = color as? UIColor {
                        view.backgroundColor = color
                }
            }
        )
        
        self.mtf_registerThemeProperty(
            ThemeProperties.borderColor.rawValue,
            valueTransformerName: MTFColorFromStringTransformerName,
            applierBlock: { (color, view) -> Void in
                if
                    let view = view as? UIView,
                    let color = color as? UIColor {
                        view.layer.borderColor = color.CGColor
                }
            }
        )
        
        self.mtf_registerThemeProperty(
            ThemeProperties.cornerRadius.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (cornerRadius, view) -> Void in
                if
                    let view = view as? UIView,
                    let cornerRadius = cornerRadius as? NSNumber {
                        view.layer.cornerRadius = CGFloat(cornerRadius.floatValue)
                }
            }
        )
        
        self.mtf_registerThemeProperty(
            ThemeProperties.borderWidth.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (borderWidth, view) -> Void in
                if
                    let view = view as? UIView,
                    let borderWidth = borderWidth as? NSNumber {
                        view.layer.borderWidth = CGFloat(borderWidth.floatValue)
                }
            }
        )
    }
}
