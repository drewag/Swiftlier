//
//  KeyboardConstraintAdjuster.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 11/6/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public class KeyboardConstraintAdjuster: NSObject {
    @IBOutlet public var constraint: NSLayoutConstraint!
    @IBOutlet public var view: UIView!

    @IBInspectable public var offset: CGFloat = 0

    public var onKeyboardIsBeingShown: (() -> ())?
    public var onKeyboardWasShown: (() -> ())?
    public var onKeyboardIsBeingHidden: (() -> ())?
    public var onKeyboardWasHidden: (() -> ())?

    public override init() {
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    // MARK: Notifications

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue else { return }
        guard let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))

        let newConstant = keyboardRect.height + self.offset
        guard self.constraint.constant != newConstant else {
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: { () -> Void in
                self.constraint.constant = newConstant
                self.onKeyboardIsBeingShown?()
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.onKeyboardWasShown?()
            }
        )
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        guard let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue else { return }
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))

        let newConstant = self.offset
        guard self.constraint.constant != newConstant else {
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: options,
            animations: {
                self.constraint.constant = newConstant
                self.onKeyboardIsBeingHidden?()
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                self.onKeyboardWasHidden?()
            }
        )
    }
}
#endif
