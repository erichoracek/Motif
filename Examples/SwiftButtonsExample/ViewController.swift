//
//  ViewController.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/14/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit
import Motif

class ViewController: UIViewController {
    
    // MARK: - UIViewController
    
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
    
    // MARK: - UIViewController: NSCoding
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewController
    
    let theme: MTFTheme
    
    init(theme: MTFTheme) {
        self.theme = theme
        super.init(nibName: nil, bundle: nil)
    }
    
    var buttonsView: ButtonsView {
        get {
            return self.view as! ButtonsView
        }
    }
    
}
