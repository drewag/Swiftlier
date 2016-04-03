//
//  UIViewController+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/2/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension UIViewController {
    public func presentPopoverViewController(viewController: UIViewController, fromSourceView sourceView: UIView) {
        viewController.modalPresentationStyle = .Popover

        self.presentViewController(viewController, animated: true, completion: nil)

        viewController.popoverPresentationController!.permittedArrowDirections = .Any
        viewController.popoverPresentationController!.sourceView = sourceView
    }
}