//
//  UIButton+Theming.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/15/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit
import Motif

extension UIButton {
    
    public override class func initialize() {
        
        self.mtf_registerThemeProperties([
                ThemeProperties.fontName.rawValue,
                ThemeProperties.fontSize.rawValue
            ], valueTransformerNamesOrRequiredClasses: [
                NSString.self,
                NSNumber.self
            ], applierBlock: { (properties, button: AnyObject) -> Void in
                if
                    let name = properties[ThemeProperties.fontName.rawValue] as? String,
                    let size = properties[ThemeProperties.fontSize.rawValue] as? NSNumber,
                    let button = button as? UIButton {
                        button.titleLabel!.font = UIFont(name: name, size: CGFloat(size.floatValue))
                }
            }
        )
        
    }
    
}