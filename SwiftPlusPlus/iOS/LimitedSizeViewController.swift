//
//  LimitedSizeViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/18/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import UIKit

public class LimitedSizeViewController: UIViewController {
    let rootViewController: UIViewController
    let containerView = UIView()
    let keyboardConstraintAdjuster = KeyboardConstraintAdjuster()
    let maxWidth: CGFloat?
    let maxHeight: CGFloat?
    var bottomConstraint: NSLayoutConstraint!

    public init(rootViewController: UIViewController, maxWidth: CGFloat?, maxHeight: CGFloat?) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
        self.rootViewController = rootViewController

        super.init(nibName: nil, bundle: nil)

        self.keyboardConstraintAdjuster.view = self.view

        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false

        self.containerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.containerView)

        self.bottomConstraint = NSLayoutConstraint(bottomOfView: self.containerView, toView: self.view)
        self.keyboardConstraintAdjuster.constraint = self.bottomConstraint
        self.view.addConstraints([
            self.bottomConstraint,
            NSLayoutConstraint(topOfView: self.containerView, toView: self.view),
            NSLayoutConstraint(leftOfView: self.containerView, toView: self.view),
            NSLayoutConstraint(rightOfView: self.containerView, toView: self.view),
        ])

        self.modalPresentationStyle = .OverCurrentContext
        self.modalTransitionStyle = .CrossDissolve

        self.addChildViewController(rootViewController)

        self.view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.containerView.addSubview(rootViewController.view)

        self.containerView.addCenteredView(rootViewController.view, withOffset: CGPoint())

        self.containerView.addConstraints([
            NSLayoutConstraint(item: rootViewController.view, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: self.containerView, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: rootViewController.view, attribute: .Left, relatedBy: .GreaterThanOrEqual, toItem: self.containerView, attribute: .Left, multiplier: 1, constant: 0),
        ])
        if let maxWidth = maxWidth {
            let constraint = NSLayoutConstraint(item: rootViewController.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: maxWidth)
            constraint.priority = 750
            rootViewController.view.addConstraint(constraint)
        }
        if let maxHeight = maxHeight {
            let constraint = NSLayoutConstraint(item: rootViewController.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: maxHeight)
            constraint.priority = 750
            rootViewController.view.addConstraint(constraint)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if (self.maxWidth ?? 99999) < self.view.bounds.width
            || (self.maxHeight ?? 99999) < self.view.bounds.height
        {
            rootViewController.view.clipsToBounds = true
            rootViewController.view.layer.cornerRadius = 15
        }
        else {
            rootViewController.view.clipsToBounds = false
            rootViewController.view.layer.cornerRadius = 0

        }
    }
}
