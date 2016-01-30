//
//  UIViewController+Transitions.swift
//  Speller
//
//  Created by Andrew J Wagner on 11/2/15.
//  Copyright © 2015 Learn Brigade, LLC. All rights reserved.
//

import UIKit
import ObjectiveC

class ViewControllerTransition: NSObject {
    var sourceViewController: UIViewController!
    var destinationViewController: UIViewController!
    private var onTransitioningBack: (() -> ())?

    func performAnimated(animated: Bool, onComplete: (() -> Void)?) {
        self.sourceViewController.presentViewController(self.destinationViewController, animated: animated, completion: onComplete)
    }

    func reverse(animated: Bool, onComplete: (() -> Void)?) {
        self.sourceViewController.dismissViewControllerAnimated(animated, completion: onComplete)
    }
}

class NavigationPushTransition: ViewControllerTransition, UINavigationControllerDelegate {
    var performOnComplete: (() -> Void)?
    var reverseOnComplete: (() -> Void)?
    var manuallyTriggeredReverse = false

    override func performAnimated(animated: Bool, onComplete: (() -> Void)?) {
        self.performOnComplete = onComplete
        self.sourceViewController.navigationController!.pushViewController(self.destinationViewController, animated: true)
        self.sourceViewController.navigationController!.delegate = self
    }

    override func reverse(animated: Bool, onComplete: (() -> Void)?) {
        self.manuallyTriggeredReverse = true
        self.reverseOnComplete = onComplete
        self.sourceViewController.navigationController!.popViewControllerAnimated(animated)
    }

    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let block = self.onTransitioningBack where viewController == self.sourceViewController && !self.manuallyTriggeredReverse {
            block()
        }
    }

    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if let block = self.performOnComplete where viewController == self.destinationViewController {
            self.performOnComplete = nil
            block()
        }
        else if let block = self.reverseOnComplete where viewController == self.sourceViewController {
            self.reverseOnComplete = nil
            block()
        }
    }
}

extension UIViewController {
    struct Keys {
        static var Transition = "Transition"
    }

    func transitionToViewController(
        viewController: UIViewController,
        animated: Bool = true,
        embeddedInNavigationController: Bool = false,
        transition: ViewControllerTransition = ViewControllerTransition(),
        onComplete: (() -> Void)? = nil,
        onTransitioningBack: (() -> ())? = nil
        )
    {
        transition.onTransitioningBack = onTransitioningBack
        transition.sourceViewController = self
        if embeddedInNavigationController {
            let navController = UINavigationController(rootViewController: viewController)
            transition.destinationViewController = navController
        }
        else {
            transition.destinationViewController = viewController
        }
        transition.performAnimated(animated, onComplete: onComplete)
        objc_setAssociatedObject(
            viewController,
            &Keys.Transition,
            transition,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    func transitionBackAnimated(animated: Bool, onComplete: (() -> Void)?) {
        var transition = objc_getAssociatedObject(self, &Keys.Transition) as? ViewControllerTransition
        if transition == nil {
            if let navController = self.navigationController {
                transition = objc_getAssociatedObject(navController, &Keys.Transition) as? ViewControllerTransition
            }
        }

        if let transition = transition {
            if let block = transition.onTransitioningBack {
                block()
            }
            transition.reverse(animated, onComplete: {
                objc_setAssociatedObject(
                    self,
                    &Keys.Transition,
                    nil,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
                onComplete?()
            })
        }
    }
}

// MARK: Convenience

extension UIViewController {
    @IBAction func didTapBackButton(sender: AnyObject) {
        self.transitionBackAnimated(true, onComplete: nil)
    }

    func backBarButtonSystemItemWithType(type: UIBarButtonSystemItem) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: type, target: self, action: "didTapBackButton:")
    }

    func backBarButtonItemWithTitle(title: String, style: UIBarButtonItemStyle) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: style, target: self, action: "didTapBackButton:")
    }
}