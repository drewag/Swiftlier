//
//  UIViewController+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public enum PopoverPosition {
    case `default`
    case topMiddle
    case bottomMiddle
    case middle
    case custom(sourceRect: CGRect)
}

extension UIViewController {
    @discardableResult
    public func present(
        popoverViewController viewController: UIViewController,
        from sourceBarButtonItem: UIBarButtonItem,
        permittedArrowDirections: UIPopoverArrowDirection = .any,
        delegate: UIPopoverPresentationControllerDelegate? = nil
        ) -> UIPopoverPresentationController
    {
        viewController.modalPresentationStyle = .popover

        viewController.popoverPresentationController!.delegate = delegate
        viewController.popoverPresentationController!.permittedArrowDirections = permittedArrowDirections
        viewController.popoverPresentationController!.barButtonItem = sourceBarButtonItem

        self.present(viewController, animated: true, completion: nil)

        return viewController.popoverPresentationController!
    }

    @discardableResult
    public func present(
        popoverViewController viewController: UIViewController,
        fromSourceView sourceView: UIView,
        permittedArrowDirections: UIPopoverArrowDirection = .any,
        position: PopoverPosition = .default,
        delegate: UIPopoverPresentationControllerDelegate? = nil
        ) -> UIPopoverPresentationController
    {
        viewController.modalPresentationStyle = .popover

        viewController.popoverPresentationController!.permittedArrowDirections = permittedArrowDirections
        viewController.popoverPresentationController!.sourceView = sourceView
        viewController.popoverPresentationController!.delegate = delegate

        switch position {
        case .default:
            break
        case .topMiddle:
            let rect = CGRect(origin: CGPoint(x: sourceView.bounds.midX, y: sourceView.bounds.minY), size: CGSize(width: 1, height: 1))
            viewController.popoverPresentationController!.sourceRect = rect
        case .bottomMiddle:
            let rect = CGRect(origin: CGPoint(x: sourceView.bounds.midX, y: sourceView.bounds.maxY), size: CGSize(width: 1, height: 1))
            viewController.popoverPresentationController!.sourceRect = rect
        case .middle:
            let rect = CGRect(origin: CGPoint(x: sourceView.bounds.midX, y: sourceView.bounds.midY), size: CGSize(width: 1, height: 1))
            viewController.popoverPresentationController!.sourceRect = rect
        case .custom(sourceRect: let rect):
            viewController.popoverPresentationController!.sourceRect = rect
        }

        self.present(viewController, animated: true, completion: nil)

        return viewController.popoverPresentationController!
    }

    public func present(overlayViewController viewController: UIViewController) {
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve

        self.present(viewController, animated: true, completion: nil)
    }
}
#endif
