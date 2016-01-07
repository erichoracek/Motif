//
//  AppDelegate.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit
import Motif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: AppDelegate: UIApplicationDelegate
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let theme = try! MTFTheme(fromFileNamed: ThemeName)

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = ViewController(themeApplier: theme)
        window!.makeKeyAndVisible()
        
        return true
    }
}
