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

    // MARK: - Lifecycle

    init(theme: MTFTheme) {
        self.theme = theme

        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    
    override func loadView() {
        self.view = ButtonsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theme.applyClassWithName(ThemeClassNames.ButtonsView.rawValue, toObject:buttonsView)
    }

    // MARK: ViewController
    
    let theme: MTFTheme
    
    var buttonsView: ButtonsView {
        get {
            return self.view as! ButtonsView
        }
    }
    
}
