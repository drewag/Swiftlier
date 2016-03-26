//
//  KeyboardConstraintAdjuster.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/6/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import Foundation

public class KeyboardConstraintAdjuster: NSObject {
    @IBOutlet public var constraint: NSLayoutConstraint!
    @IBOutlet public var view: UIView!

    @IBInspectable public var offset: CGFloat = 0

    public var onKeyboardIsBeingShown: (() -> ())?
    public var onKeyboardWasShown: (() -> ())?

    override public func awakeFromNib() {
        super.awakeFromNib()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    // MARK: Notifications

    func keyboardWillShow(notification: NSNotification) {
        let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if frame != nil && duration != nil {
            self.onKeyboardIsBeingShown?()
            UIView.animateWithDuration(
                duration!,
                delay: 0,
                options: options,
                animations: { () -> Void in
                    self.constraint.constant = frame!.size.height + self.offset
                    self.view.layoutIfNeeded()
                },
                completion: { _ in
                    self.onKeyboardWasShown?()
                }
            )
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        if frame != nil && duration != nil {
            UIView.animateWithDuration(duration!, delay: 0, options: options, animations: { () -> Void in
                self.constraint.constant = self.offset
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}