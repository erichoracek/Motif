//
//  AppDelegate.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

import UIKit
import AUTTheming

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: AppDelegate: UIApplicationDelegate
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds);
        window!.rootViewController = ViewController(theme: theme)
        window!.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: AppDelegate
    
    let theme = AUTTheme(fromJSONThemeNamed: ThemeName, error: nil)
    
}
