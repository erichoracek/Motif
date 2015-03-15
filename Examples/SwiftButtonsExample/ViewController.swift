//
//  ViewController.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Automatic Labs, Inc. All rights reserved.
//

import UIKit
import AUTTheming

class ViewController: UIViewController {

    // MARK: - UIView
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = ButtonsView.new()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theme.applyClassWithName(ThemeClassNames.ButtonsView.rawValue, toObject:buttonsView)
        
        buttonsView.saveButton.setTitle("Save", forState: UIControlState.Normal)
        buttonsView.deleteButton.setTitle("Delete", forState: UIControlState.Normal)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: ViewController
    
    let theme: AUTTheme
    
    init(theme: AUTTheme) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    var buttonsView: ButtonsView {
        get {
            return self.view as! ButtonsView
        }
    }
    
}
