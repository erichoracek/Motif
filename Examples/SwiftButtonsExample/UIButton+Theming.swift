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
            applierBlock: { (themeClass, button, error) -> Bool in
                guard let button = button as? UIButton else { return false }
                guard let themeClass = themeClass as? MTFThemeClass else { return false }

                do {
                    try themeClass.applyTo(button.titleLabel!)
                } catch let applyError as NSError {
                    error.memory = applyError
                    return false
                }
                return true
            })
    }
}
