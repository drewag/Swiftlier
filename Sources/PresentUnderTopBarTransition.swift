//
//  PresentUnderTopBarTransition.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/5/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

@available(iOS 8.0, *)
class PresentUnderTopBarTransition: ViewControllerTransition {
    let containerView = UIView()

    override func perform(animated: Bool, onComplete: (() -> Void)?) {
        self.sourceViewController.addChildViewController(self.destinationViewController)

        guard let sourceView = self.sourceViewController.view,
            let destinationView = self.destinationViewController.view
            else
        {
            return
        }

        sourceView.addSubview(containerView)
        self.setupContainerView(containerView, withDestinationView: destinationView)

        let topConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.sourceViewController.topLayoutGuide,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        let belowConstraint = NSLayoutConstraint(
            item: containerView,
            attribute: .top,
            relatedBy: .equal,
            toItem: sourceView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        let heightConstraint = NSLayoutConstraint(sameHeightFor: containerView, and: sourceView)
        let leftConstraint = NSLayoutConstraint(leftOf: containerView, to: sourceView)
        let rightConstraint = NSLayoutConstraint(rightOf: containerView, to: sourceView)
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
            UIView.animate(withDuration: 0.3,
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

    override func reverse(_ animated: Bool, onComplete: (() -> Void)?) {
        guard let sourceView = self.sourceViewController.view,
            let destinationView = self.destinationViewController.view
            else
        {
            return
        }

        func animations() {
            destinationView.frame = destinationView.frame.offsetBy(dx: 0, dy: destinationView.frame.height)
        }

        func completion(_: Bool) {
            self.containerView.removeFromSuperview()
            self.destinationViewController.removeFromParentViewController()
            onComplete?()
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
        }
        else {
            animations()
            completion(true)
        }
    }
}

@available(iOS 8.0, *)
private extension PresentUnderTopBarTransition {
    func setupContainerView(_ containerView: UIView, withDestinationView destinationView: UIView) {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(destinationView)
        containerView.addSubview(spacerView)

        containerView.addConstraints([
            // Horizontal
            NSLayoutConstraint(leftOf: spacerView, to: containerView),
            NSLayoutConstraint(rightOf: spacerView, to: containerView),
            NSLayoutConstraint(leftOf: destinationView, to: containerView),
            NSLayoutConstraint(rightOf: destinationView, to: containerView),

            // Vertical
            NSLayoutConstraint(topOf: destinationView, to: containerView),
            NSLayoutConstraint(item: spacerView, attribute: .top, relatedBy: .equal, toItem: destinationView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(bottomOf: spacerView, to: containerView),
        ])

        self.sourceViewController.view.addConstraints([
            // Height
            NSLayoutConstraint(item: spacerView, attribute: .height, relatedBy: .equal, toItem: self.sourceViewController.topLayoutGuide, attribute: .height, multiplier: 1, constant: 0),
        ])
    }
}
#endif
