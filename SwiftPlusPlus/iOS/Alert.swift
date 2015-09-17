//
//  Alert.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/10/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit
import ObjectiveC

class Alert: NSObject {
    private let onButtonClicked: (buttonTitle: String?, textFieldText: String?) -> ()

    private init(onButtonClicked: (buttonTitle: String?, textFieldText: String?) -> ()) {
        self.onButtonClicked = onButtonClicked

        super.init()
    }
}

extension Alert: UIAlertViewDelegate {
    @available(iOS, introduced=2.0, deprecated=9.0, message="Use showAlertController instead")
    func alertView(alertView: UIAlertView, clickedButtonAtIndex: Int) {
        let title = alertView.buttonTitleAtIndex(clickedButtonAtIndex)
        var textFieldText: String?
        if let textField = alertView.textFieldAtIndex(0) {
            textFieldText = textField.text
        }
        self.onButtonClicked(buttonTitle: title, textFieldText: textFieldText)
    }
}

extension UIViewController {
    public func showAlertWithTitle(
        title: String,
        message: String,
        cancelButtonTitle: String? = nil,
        otherButtonTitles: [String]? = nil,
        textFieldPlaceholder: String? = nil,
        onButtonClicked: ((buttonTitle: String?, textFieldText: String?) -> ())? = nil
        )
    {
        if #available(iOS 8.0, *) {
            Alert.showAlertController(
                title,
                message: message,
                cancelButtonTitle: cancelButtonTitle,
                otherButtonTitles: otherButtonTitles,
                textFieldPlaceholder: textFieldPlaceholder,
                onButtonClicked: onButtonClicked,
                fromViewController: self
            )
        }
        else {
            Alert.showAlertView(
                title,
                message: message,
                cancelButtonTitle: cancelButtonTitle,
                otherButtonTitles: otherButtonTitles,
                textFieldPlaceholder: textFieldPlaceholder,
                onButtonClicked: onButtonClicked
            )
        }
    }
}

private extension Alert {
    struct Keys {
        static var Delegate = "Delegate"
    }

    @available(iOS, introduced=2.0, deprecated=9.0, message="Use showAlertController instead")
    class func showAlertView(
        title: String,
        message: String,
        cancelButtonTitle: String?,
        otherButtonTitles: [String]?,
        textFieldPlaceholder: String? = nil,
        onButtonClicked: ((buttonTitle: String?, textFieldText: String?) -> ())?
        )
    {
        var delegate: UIAlertViewDelegate?
        if let onButtonClicked = onButtonClicked {
            delegate = Alert(onButtonClicked: onButtonClicked)
        }

        let alert = UIAlertView(title: title, message: message, delegate: delegate, cancelButtonTitle: cancelButtonTitle)

        if textFieldPlaceholder != nil {
            alert.alertViewStyle = .PlainTextInput
        }

        for otherButtonTitle in otherButtonTitles ?? [] {
            alert.addButtonWithTitle(otherButtonTitle)
        }

        if let delegate = delegate {
            objc_setAssociatedObject(
                alert,
                &Keys.Delegate,
                delegate,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }

        alert.show()
    }

    @available(iOS 8.0, *)
    class func showAlertController(
        title: String,
        message: String,
        cancelButtonTitle: String?,
        otherButtonTitles: [String]?,
        textFieldPlaceholder: String?,
        onButtonClicked: ((buttonTitle: String?, textFieldText: String?) -> ())?,
        fromViewController: UIViewController
        )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        var promptTextField: UITextField?
        if let placeholder = textFieldPlaceholder {
            alert.addTextFieldWithConfigurationHandler { textField in
                textField.placeholder = placeholder
                promptTextField = textField
            }
        }

        func handler(action: UIAlertAction!) {
            if let block = onButtonClicked {
                block(buttonTitle: action.title, textFieldText: promptTextField?.text)
            }
        }


        if let cancelButtonTitle = cancelButtonTitle {
            alert.addAction(UIAlertAction(
                title: cancelButtonTitle,
                style: .Cancel,
                handler: handler
                ))
        }
        for otherTitle in otherButtonTitles ?? [] {
            alert.addAction(UIAlertAction(
                title: otherTitle,
                style: .Default,
                handler: handler
                ))
        }

        fromViewController.presentViewController(alert, animated: true, completion: nil)
    }
}
