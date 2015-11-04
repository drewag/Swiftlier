//
//  ZoomThroughTransition.swift
//  Speller
//
//  Created by Andrew J Wagner on 10/13/15.
//  Copyright © 2015 Learn Brigade, LLC. All rights reserved.
//

import UIKit

class ZoomThroughTransition: ViewControllerTransition {
    let zoomThroughView: UIView
    var shouldZoomOut = true

    init(zoomThroughView: UIView) {
        self.zoomThroughView = zoomThroughView
        super.init()
    }

    override func performAnimated(animated: Bool, onComplete: (() -> Void)?) {
        let zoomThroughFrame = zoomThroughView.frame
        let sourceView = self.sourceViewController.view
        let destinationView = self.destinationViewController.view
        let windowBounds = UIApplication.sharedApplication().keyWindow!.bounds

        destinationView.frame = sourceView.frame
        sourceView.superview!.insertSubview(destinationView, belowSubview: sourceView)

        UIView.animateWithDuration(0.3,
            animations: {
                let scale = windowBounds.height / zoomThroughFrame.height
                let yInView: CGFloat
                if #available(iOS 8.0, *) {
                    yInView = sourceView.convertPoint(zoomThroughFrame.origin, fromCoordinateSpace: self.zoomThroughView.superview!).y
                } else {
                    yInView = sourceView.convertPoint(zoomThroughFrame.origin, fromView: self.zoomThroughView.superview!).y
                }
                let translateForTop = sourceView.bounds.height * (scale - 1) / 2
                let translateForButton = -yInView * scale
                let translate = translateForTop + translateForButton

                var transform = CGAffineTransformMakeTranslation(0, translate)
                transform = CGAffineTransformScale(transform, scale, scale)

                sourceView.transform = transform
                sourceView.alpha = 0
            },
            completion: { _ in
                self.sourceViewController.presentViewController(self.destinationViewController, animated: false, completion: onComplete)
            }
        )
    }

    override func reverse(animated: Bool, onComplete: (() -> Void)?) {
        guard self.shouldZoomOut else {
            super.reverse(animated, onComplete: onComplete)
            return
        }

        let sourceView = self.sourceViewController.view
        let destinationView = self.destinationViewController.view

        UIApplication.sharedApplication().keyWindow!.insertSubview(sourceView, aboveSubview: destinationView)

        UIView.animateWithDuration(0.3,
            animations: {
                sourceView.transform = CGAffineTransformIdentity
                sourceView.alpha = 1
            },
            completion: { completed in
                self.destinationViewController.dismissViewControllerAnimated(false, completion: nil)
            }
        )
    }
}
