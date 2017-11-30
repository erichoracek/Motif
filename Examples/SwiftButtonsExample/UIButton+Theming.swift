//
//  UIButton+Theming.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/15/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit
import Motif

extension Themeable where ApplicantType == UIButton {

    static func registerProperties() {
        ApplicantType.mtf_registerThemeProperty(
            ThemeProperties.titleText.rawValue,
            requiringValueOf: MTFThemeClass.self,
            applierBlock: { (themeClass, button, error) -> Bool in
                guard let button = button as? UIButton else { return false }
                guard let themeClass = themeClass as? MTFThemeClass else { return false }

                do {
                    try themeClass.apply(to: button.titleLabel!)
                } catch let applyError as NSError {
                    error?.pointee = applyError
                    return false
                }
                return true
            })
    }
    
}
