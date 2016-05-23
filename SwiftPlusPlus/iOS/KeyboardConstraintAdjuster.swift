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

//    private var currentKeyboardHeight = 0

    public var onKeyboardIsBeingShown: (() -> ())?
    public var onKeyboardWasShown: (() -> ())?
    public var onKeyboardIsBeingHidden: (() -> ())?
    public var onKeyboardWasHidden: (() -> ())?

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
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return }
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let keyboard = self.view.convertRect(frame, fromView:self.view.window)
        let displayHeight = self.view.frame.height - keyboard.minY

        UIView.animateWithDuration(
            duration,
            delay: 0,
            options: options,
            animations: { () -> Void in
                self.onKeyboardIsBeingShown?()
                self.constraint.constant = displayHeight + self.offset
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.onKeyboardWasShown?()
            }
        )
    }

    func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))

        UIView.animateWithDuration(
            duration,
            delay: 0,
            options: options,
            animations: {
                self.onKeyboardIsBeingHidden?()
                self.constraint.constant = self.offset
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.onKeyboardWasHidden?()
            }
        )
    }
}