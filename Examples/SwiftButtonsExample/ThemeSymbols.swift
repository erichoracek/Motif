//
//  ThemeSymbols.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import Foundation

let ThemeName = "Theme"

enum ThemeConstantKeys: String {
    case WhiteColor = "WhiteColor"
    case RedColor = "RedColor"
    case BlueColor = "BlueColor"
    case FontName = "FontName"
}

enum ThemeClassNames: String {
    case Button = "Button"
    case ContentBackground = "ContentBackground"
    case DestructiveButton = "DestructiveButton"
    case ButtonsText = "ButtonsText"
    case ButtonsView = "ButtonsView"
}

enum ThemeProperties: String {
    case fontSize = "fontSize"
    case titleText = "titleText"
    case tintColor = "tintColor"
    case deleteButton = "deleteButton"
    case borderColor = "borderColor"
    case borderWidth = "borderWidth"
    case cornerRadius = "cornerRadius"
    case fontName = "fontName"
    case contentEdgeInsets = "contentEdgeInsets"
    case backgroundColor = "backgroundColor"
    case saveButton = "saveButton"
}
