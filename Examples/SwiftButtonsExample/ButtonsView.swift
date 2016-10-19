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
        saveButton = UIButton(type: .system)
        deleteButton = UIButton(type: .system)

        saveButton.setTitle("Save", for: UIControlState())
        deleteButton.setTitle("Delete", for: UIControlState())

        super.init(frame: frame)

        let stackView = UIStackView(arrangedSubviews: [ saveButton, deleteButton ])
        stackView.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override class var requiresConstraintBasedLayout : Bool {
        return true
    }

    // MARK: - ButtonsView
    
    let saveButton: UIButton
    let deleteButton: UIButton
}
