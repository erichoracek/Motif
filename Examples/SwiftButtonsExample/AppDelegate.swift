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
        var error: NSError?
        let theme = MTFTheme(fromFileNamed: ThemeName, error: &error)
        assert(error == nil, "Error loading theme: \(error)")
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = ViewController(theme: theme)
        window!.makeKeyAndVisible()
        
        return true
    }
}
