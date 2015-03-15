//
//  UIView+Theming.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

import UIKit
import AUTTheming

extension UIView {
    
    public override class func initialize() {
        
        self.aut_registerThemeProperty(
            ThemeProperties.backgroundColor.rawValue,
            valueTransformerName: AUTColorFromStringTransformerName,
            applierBlock: { (color, view) -> Void in
                let view: UIView = view as! UIView
                let color: UIColor = color as! UIColor
                view.backgroundColor = color
            }
        )
        
        self.aut_registerThemeProperty(
            ThemeProperties.borderColor.rawValue,
            valueTransformerName: AUTColorFromStringTransformerName,
            applierBlock: { (color, view) -> Void in
                let view: UIView = view as! UIView
                let color: UIColor = color as! UIColor
                view.layer.borderColor = color.CGColor
            }
        )
        
        self.aut_registerThemeProperty(
            ThemeProperties.cornerRadius.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (cornerRadius, view) -> Void in
                let view = view as! UIView
                let cornerRadius = cornerRadius as! NSNumber
                view.layer.cornerRadius = CGFloat(cornerRadius.floatValue)
            }
        )
        
        self.aut_registerThemeProperty(
            ThemeProperties.borderWidth.rawValue,
            requiringValueOfClass: NSNumber.self,
            applierBlock: { (borderWidth, view) -> Void in
                let view = view as! UIView
                let borderWidth = borderWidth as! NSNumber
                view.layer.borderWidth = CGFloat(borderWidth.floatValue)
            }
        )
        
    }
}
