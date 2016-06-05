//
//  UIViewController+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension UIViewController {
    public func present(popoverViewController viewController: UIViewController, fromSourceView sourceView: UIView, sourceRect: CGRect? = nil, permittedArrowDirections: UIPopoverArrowDirection = .Any) {
        viewController.modalPresentationStyle = .Popover

        self.presentViewController(viewController, animated: true, completion: nil)

        viewController.popoverPresentationController!.permittedArrowDirections = permittedArrowDirections
        viewController.popoverPresentationController!.sourceView = sourceView
        if let sourceRect = sourceRect {
            viewController.popoverPresentationController!.sourceRect = sourceRect
        }
    }

    public func present(overlayViewController viewController: UIViewController) {
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.modalTransitionStyle = .CrossDissolve

        self.presentViewController(viewController, animated: true, completion: nil)
    }
}