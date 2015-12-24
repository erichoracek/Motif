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
        guard self === UILabel.self else { return }
        
        self.mtf_registerThemeProperties([
                ThemeProperties.fontName.rawValue,
                ThemeProperties.fontSize.rawValue
            ],
            requiringValuesOfType: [
                NSString.self,
                NSNumber.self
            ],
            applierBlock: { (properties, label) -> Void in
                guard let name = properties[ThemeProperties.fontName.rawValue] as? String else { return }
                guard let size = properties[ThemeProperties.fontSize.rawValue] as? NSNumber else { return }
                guard let label = label as? UILabel else { return }

                label.font = UIFont(name: name, size: CGFloat(size.floatValue))
            })
    }
}
