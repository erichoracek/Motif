//
//  ButtonsView.swift
//  SwiftButtonsExample
//
//  Created by Eric Horacek on 3/15/15.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

import UIKit

class ButtonsView: UIView {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        saveButton = UIButton(type: .System)
        deleteButton = UIButton(type: .System)

        saveButton.setTitle("Save", forState: .Normal)
        deleteButton.setTitle("Delete", forState: .Normal)

        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [ saveButton, deleteButton ])
        stackView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        stackView.layoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        stackView.distribution = .FillEqually
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        stackView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        stackView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }

    // MARK: - ButtonsView
    
    let saveButton: UIButton
    let deleteButton: UIButton
}
