//
//  ThemeSymbols.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

import Foundation

let ThemeName = "Theme"

enum ThemeConstantKeys: String {
    case WhiteColor = "WhiteColor"
    case RegularFontName = "RegularFontName"
    case H5FontSize = "H5FontSize"
    case BlueColor = "BlueColor"
    case RedColor = "RedColor"
}

enum ThemeClassNames: String {
    case Button = "Button"
    case PrimaryButton = "PrimaryButton"
    case DestructiveButton = "DestructiveButton"
    case ContentBackground = "ContentBackground"
    case ButtonsView = "ButtonsView"
}

enum ThemeProperties: String {
    case fontSize = "fontSize"
    case tintColor = "tintColor"
    case fontName = "fontName"
    case borderColor = "borderColor"
    case borderWidth = "borderWidth"
    case cornerRadius = "cornerRadius"
    case contentEdgeInsets = "contentEdgeInsets"
    case backgroundColor = "backgroundColor"
}
