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

    init(themeApplier: MTFThemeApplier) {
        self.themeApplier = themeApplier

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    
    override func loadView() {
        self.view = ButtonsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try themeApplier.applyClass(withName: ThemeClassNames.ButtonsView.rawValue, to:buttonsView)
        } catch {
            print(error)
        }
    }

    // MARK: ViewController
    
    let themeApplier: MTFThemeApplier
    
    var buttonsView: ButtonsView {
        return self.view as! ButtonsView
    }
}
