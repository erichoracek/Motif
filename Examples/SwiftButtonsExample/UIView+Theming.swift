//
//  UIView+Theming.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit
import Motif

extension Themeable where ApplicantType == UIView {

    static func registerProperties() {
        ApplicantType.mtf_registerThemeProperty(
            ThemeProperties.backgroundColor.rawValue,
            requiringValueOf: UIColor.self,
            applierBlock: { (color, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let color = color as? UIColor else { return false }

                view.backgroundColor = color

                return true
            })
        
        ApplicantType.mtf_registerThemeProperty(
            ThemeProperties.borderColor.rawValue,
            requiringValueOf: UIColor.self,
            applierBlock: { (color, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let color = color as? UIColor else { return false }

                view.layer.borderColor = color.cgColor

                return true
            })
        
        ApplicantType.mtf_registerThemeProperty(
            ThemeProperties.cornerRadius.rawValue,
            requiringValueOf: NSNumber.self,
            applierBlock: { (cornerRadius, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let cornerRadius = cornerRadius as? NSNumber else { return false }

                view.layer.cornerRadius = CGFloat(cornerRadius.floatValue)

                return true
            })
        
        ApplicantType.mtf_registerThemeProperty(
            ThemeProperties.borderWidth.rawValue,
            requiringValueOf: NSNumber.self,
            applierBlock: { (borderWidth, view, _) -> Bool in
                guard let view = view as? UIView else { return false }
                guard let borderWidth = borderWidth as? NSNumber else { return false }

                view.layer.borderWidth = CGFloat(borderWidth.floatValue)

                return true
            })
    }
    
}
