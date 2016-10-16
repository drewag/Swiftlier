//
//  UIViewController+Transitions.swift
//  Speller
//
//  Created by Andrew J Wagner on 11/2/15.
//  Copyright © 2015 Learn Brigade, LLC. All rights reserved.
//

#if os(iOS)
import UIKit
import ObjectiveC

class ViewControllerTransition: NSObject {
    var sourceViewController: UIViewController!
    var destinationViewController: UIViewController!
    fileprivate var onTransitioningBack: (() -> ())?

    func perform(animated: Bool, onComplete: (() -> Void)?) {
        self.sourceViewController.present(self.destinationViewController, animated: animated, completion: onComplete)
    }

    func reverse(_ animated: Bool, onComplete: (() -> Void)?) {
        self.sourceViewController.dismiss(animated: animated, completion: onComplete)
    }
}

class NavigationPushTransition: ViewControllerTransition, UINavigationControllerDelegate {
    var performOnComplete: (() -> Void)?
    var reverseOnComplete: (() -> Void)?
    var manuallyTriggeredReverse = false

    override func perform(animated: Bool, onComplete: (() -> Void)?) {
        self.performOnComplete = onComplete
        self.sourceViewController.navigationController!.pushViewController(self.destinationViewController, animated: true)
        self.sourceViewController.navigationController!.delegate = self
    }

    override func reverse(_ animated: Bool, onComplete: (() -> Void)?) {
        self.manuallyTriggeredReverse = true
        self.reverseOnComplete = onComplete
        self.sourceViewController.navigationController!.popViewController(animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let block = self.onTransitioningBack , viewController == self.sourceViewController && !self.manuallyTriggeredReverse {
            block()
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let block = self.performOnComplete , viewController == self.destinationViewController {
            self.performOnComplete = nil
            block()
        }
        else if let block = self.reverseOnComplete , viewController == self.sourceViewController {
            self.reverseOnComplete = nil
            block()
        }
    }
}

extension UIViewController {
    struct Keys {
        static var Transition = "Transition"
    }

    func transition(
        to viewController: UIViewController,
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
        transition.perform(animated: animated, onComplete: onComplete)
        objc_setAssociatedObject(
            viewController,
            &Keys.Transition,
            transition,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
    }

    func transitionBack(animated: Bool, onComplete: (() -> Void)?) {
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
    @IBAction func didTapBackButton(_ sender: AnyObject) {
        self.transitionBack(animated: true, onComplete: nil)
    }

    func backBarButtonSystemItem(withType type: UIBarButtonSystemItem) -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: type, target: self, action: #selector(didTapBackButton(_:)))
    }

    func backBarButtonItem(withTitle title: String, style: UIBarButtonItemStyle) -> UIBarButtonItem {
        return UIBarButtonItem(title: title, style: style, target: self, action: #selector(didTapBackButton(_:)))
    }
}
#endif
