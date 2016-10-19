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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let theme = try! MTFTheme(fromFileNamed: ThemeName)

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = ViewController(themeApplier: theme)
        window!.makeKeyAndVisible()
        
        return true
    }
}
