//
//  UILabel+Theming.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 4/7/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import Foundation
import Motif

extension UILabel {
    public override class func initialize() {
        if self !== UILabel.self { return }
        
        self.mtf_registerThemeProperties([
            ThemeProperties.fontName.rawValue,
            ThemeProperties.fontSize.rawValue
            ], requiringValuesOfType: [
                NSString.self,
                NSNumber.self
            ], applierBlock: { (properties, label) -> Void in
                if
                    let name = properties[ThemeProperties.fontName.rawValue] as? String,
                    let size = properties[ThemeProperties.fontSize.rawValue] as? NSNumber,
                    let label = label as? UILabel {
                        label.font = UIFont(name: name, size: CGFloat(size.floatValue))
                }
            }
        )
    }
}
