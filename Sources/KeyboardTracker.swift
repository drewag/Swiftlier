//
//  KeyboardTracker.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/25/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

public class KeyboardTracker {
    public private(set) var isKeyboardShowing: Bool = false

    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        self.isKeyboardShowing = true
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        self.isKeyboardShowing = false
    }
}
#endif
