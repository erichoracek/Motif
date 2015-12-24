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
        guard self === UIButton.self else { return }
        
        self.mtf_registerThemeProperty(
            ThemeProperties.titleText.rawValue,
            requiringValueOfClass: MTFThemeClass.self,
            applierBlock: { (themeClass, button) -> Void in
                guard let button = button as? UIButton else { return }
                guard let themeClass = themeClass as? MTFThemeClass else { return }

                themeClass.applyToObject(button.titleLabel!)
            })
    }
}
