//
//  PresentUnderTopBarTransition.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/5/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)
class PresentUnderTopBarTransition: ViewControllerTransition {
    let containerView = UIView()

    override func performAnimated(animated: Bool, onComplete: (() -> Void)?) {
        self.sourceViewController.addChildViewController(self.destinationViewController)

        let sourceView = self.sourceViewController.view
        let destinationView = self.destinationViewController.view
        sourceView.addSubview(containerView)
        self.setupContainerView(containerView, withDestinationView: destinationView)

        let topConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.sourceViewController.topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0
        )
        let belowConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: sourceView,
            attribute: .Bottom,
            multiplier: 1,
            constant: 0
        )
        let heightConstraint = NSLayoutConstraint(sameHeightForView: containerView, andView: sourceView)
        let leftConstraint = NSLayoutConstraint(leftOfView: containerView, toView: sourceView)
        let rightConstraint = NSLayoutConstraint(rightOfView: containerView, toView: sourceView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        destinationView.translatesAutoresizingMaskIntoConstraints = false
        sourceView.addConstraints([
            belowConstraint,
            heightConstraint,
            leftConstraint,
            rightConstraint
        ])

        func animations() {
            sourceView.removeConstraint(belowConstraint)
            sourceView.addConstraint(topConstraint)
            sourceView.layoutIfNeeded()
        }

        if animated {
            sourceView.layoutIfNeeded()
            UIView.animateWithDuration(0.3,
                animations: animations,
                completion: { _ in
                    onComplete?()
                }
            )
        }
        else {
            animations()
            onComplete?()
        }
    }

    override func reverse(animated: Bool, onComplete: (() -> Void)?) {
        let sourceView = self.sourceViewController.view
        let destinationView = self.destinationViewController.view

        func animations() {
            destinationView.frame = destinationView.frame.offsetBy(dx: 0, dy: destinationView.frame.height)
        }

        func completion(_: Bool) {
            self.containerView.removeFromSuperview()
            self.destinationViewController.removeFromParentViewController()
            onComplete?()
        }

        if animated {
            UIView.animateWithDuration(0.3, animations: animations, completion: completion)
        }
        else {
            animations()
            completion(true)
        }
    }
}

@available(iOS 8.0, *)
private extension PresentUnderTopBarTransition {
    func setupContainerView(containerView: UIView, withDestinationView destinationView: UIView) -> UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(destinationView)
        containerView.addSubview(spacerView)

        containerView.addConstraints([
            // Horizontal
            NSLayoutConstraint(leftOfView: spacerView, toView: containerView),
            NSLayoutConstraint(rightOfView: spacerView, toView: containerView),
            NSLayoutConstraint(leftOfView: destinationView, toView: containerView),
            NSLayoutConstraint(rightOfView: destinationView, toView: containerView),

            // Vertical
            NSLayoutConstraint(topOfView: destinationView, toView: containerView),
            NSLayoutConstraint(item: spacerView, attribute: .Top, relatedBy: .Equal, toItem: destinationView, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(bottomOfView: spacerView, toView: containerView),
        ])

        self.sourceViewController.view.addConstraints([
            // Height
            NSLayoutConstraint(item: spacerView, attribute: .Height, relatedBy: .Equal, toItem: self.sourceViewController.topLayoutGuide, attribute: .Height, multiplier: 1, constant: 0),
        ])

        return containerView
    }
}