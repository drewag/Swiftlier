//
//  UIViewController+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public enum PopoverPosition {
    case Default
    case TopMiddle
    case Custom(sourceRect: CGRect)
}

extension UIViewController {
    public func present(popoverViewController viewController: UIViewController, from sourceBarButtonItem: UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection = .Any) {
        viewController.modalPresentationStyle = .Popover

        self.presentViewController(viewController, animated: true, completion: nil)

        viewController.popoverPresentationController!.permittedArrowDirections = permittedArrowDirections
        viewController.popoverPresentationController!.barButtonItem = sourceBarButtonItem
    }

    public func present(popoverViewController viewController: UIViewController, fromSourceView sourceView: UIView, permittedArrowDirections: UIPopoverArrowDirection = .Any, position: PopoverPosition = .Default) {
        viewController.modalPresentationStyle = .Popover

        self.presentViewController(viewController, animated: true, completion: nil)

        viewController.popoverPresentationController!.permittedArrowDirections = permittedArrowDirections
        viewController.popoverPresentationController!.sourceView = sourceView

        switch position {
        case .Default:
            break
        case .TopMiddle:
            let rect = CGRect(origin: CGPoint(x: sourceView.bounds.midX, y: sourceView.bounds.minY), size: CGSize(width: 1, height: 1))
            viewController.popoverPresentationController!.sourceRect = rect
        case .Custom(sourceRect: let rect):
            viewController.popoverPresentationController!.sourceRect = rect
        }
    }

    public func present(overlayViewController viewController: UIViewController) {
        viewController.modalPresentationStyle = .OverCurrentContext
        viewController.modalTransitionStyle = .CrossDissolve

        self.presentViewController(viewController, animated: true, completion: nil)
    }
}