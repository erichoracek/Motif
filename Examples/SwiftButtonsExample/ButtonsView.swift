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
        super.init(frame: frame)
        
        addSubview(saveButton)
        addSubview(deleteButton)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIView

    override class func requiresConstraintBasedLayout() -> Bool {
        return true
    }
    
    override func updateConstraints() {
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "[saveButton(145)]-5-[deleteButton(145)]",
            options: NSLayoutFormatOptions.allZeros,
            metrics: nil,
            views: ["saveButton": saveButton, "deleteButton": deleteButton])

        let saveButtonCenterYConstraint = NSLayoutConstraint(
            item: saveButton,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0)

        let deleteButtonCenterYConstraint = NSLayoutConstraint(
            item: deleteButton,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0)

        let buttonHorizontalCenteringConstraint = NSLayoutConstraint(
            item: saveButton,
            attribute: .Right,
            relatedBy: .Equal,
            toItem: self,
            attribute: .CenterX,
            multiplier: 1,
            constant: -2.5)

        addConstraints(horizontalConstraints)
        addConstraint(saveButtonCenterYConstraint)
        addConstraint(deleteButtonCenterYConstraint)
        addConstraint(buttonHorizontalCenteringConstraint)

        super.updateConstraints()
    }

    // MARK: - ButtonsView
    
    let saveButton: UIButton = {
        let button = UIButton.buttonWithType(.System) as! UIButton
        button.setTitle("Save", forState: .Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton.buttonWithType(.System) as! UIButton
        button.setTitle("Delete", forState: .Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        return button
    }()
}
