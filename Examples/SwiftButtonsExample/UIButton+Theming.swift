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
        if self !== UIButton.self {
            return
        }
        
        self.mtf_registerThemeProperty(
            ThemeProperties.titleText.rawValue,
            requiringValueOfClass: MTFThemeClass.self,
            applierBlock: { (themeClass, button) -> Void in
                if
                    let button = button as? UIButton,
                    let themeClass = themeClass as? MTFThemeClass {
                        themeClass.applyToObject(button.titleLabel!)
                }
            }
        )
    }
}
