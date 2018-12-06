//
//  UINavigationController+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 12/5/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, onComplete: @escaping () -> ()) {
        self.pushViewController(viewController, animated: animated)


        if let coordinator = self.transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                onComplete()
            }
        } else {
            onComplete()
        }
    }

    public func popViewController(animated: Bool, onComplete: @escaping () -> ()) {
        self.popViewController(animated: animated)

        if let coordinator = self.transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                onComplete()
            }
        } else {
            onComplete()
        }
    }

    public func popToRootViewController(animated: Bool, onComplete: @escaping () -> ()) {
        self.popToRootViewController(animated: animated)

        if let coordinator = self.transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                onComplete()
            }
        } else {
            onComplete()
        }
    }
}
#endif
