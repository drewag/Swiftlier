//
//  Alert.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/10/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)

import UIKit
import ObjectiveC

class Alert: NSObject {
    private let onButtonClicked: (_ buttonTitle: String?, _ textFieldText: String?) -> ()

    private init(onButtonClicked: @escaping (_ buttonTitle: String?, _ textFieldText: String?) -> ()) {
        self.onButtonClicked = onButtonClicked

        super.init()
    }
}

public final class AlertAction {
    let name: String
    let handler: (() -> ())?

    init(name: String, handler: (() -> ())?) {
        self.name = name
        self.handler = handler
    }

    public static func action(_ name: String, handler: (() -> ())? = nil) -> AlertAction {
        return AlertAction(name: name, handler: handler)
    }
}

public final class TextAction {
    let name: String
    let handler: ((_ text: String) -> ())?

    init(name: String, handler: ((_ text: String) -> ())?) {
        self.name = name
        self.handler = handler
    }

    public static func action(_ name: String, handler: ((_ text: String) -> ())? = nil) -> TextAction {
        return TextAction(name: name, handler: handler)
    }
}

extension UIViewController {
    public func showAlert(withError error: UserReportableError) {
        self.showAlert(
            withTitle: error.alertTitle,
            message: error.alertMessage
        )
    }

    public func showAlert(
        withTitle title: String,
        message: String,
        cancel: AlertAction? = nil,
        other: [AlertAction] = []
        )
    {
        func onTapped(buttonTitle: String?, textFieldText: String?) {
            if let action = cancel, action.name == buttonTitle {
                action.handler?()
                return
            }
            for action in other {
                if action.name == buttonTitle {
                    action.handler?()
                    return
                }
            }
        }

        var other = other
        if cancel == nil && other.isEmpty {
            other.append(.action("OK"))
        }
        Alert.showAlertController(
            title: title,
            message: message,
            cancelButtonTitle: cancel?.name,
            otherButtonTitles: other.map({$0.name}),
            textFieldPlaceholder: nil,
            textFieldDefault: nil,
            onButtonClicked: onTapped,
            fromViewController: self
        )
    }

    public func showTextInput(
        withTitle title: String,
        message: String,
        textFieldPlaceholder: String? = nil,
        textFieldDefault: String? = nil,
        cancel: TextAction? = nil,
        other: [TextAction] = []
        )
    {
        func onTapped(buttonTitle: String?, textFieldText: String?) {
            if let action = cancel, action.name == buttonTitle {
                action.handler?(textFieldText ?? "")
                return
            }
            for action in other {
                if action.name == buttonTitle {
                    action.handler?(textFieldText ?? "")
                    return
                }
            }
        }

        var other = other
        if cancel == nil && other.isEmpty {
            other.append(.action("OK"))
        }
        Alert.showAlertController(
            title: title,
            message: message,
            cancelButtonTitle: cancel?.name,
            otherButtonTitles: other.map({$0.name}),
            textFieldPlaceholder: textFieldPlaceholder ?? "",
            textFieldDefault: textFieldDefault,
            onButtonClicked: onTapped,
            fromViewController: self
        )
    }
}

private extension Alert {
    struct Keys {
        static var Delegate = "Delegate"
    }

    class func showAlertController(
        title: String,
        message: String,
        cancelButtonTitle: String?,
        otherButtonTitles: [String]?,
        textFieldPlaceholder: String?,
        textFieldDefault: String? = nil,
        onButtonClicked: ((_ buttonTitle: String?, _ textFieldText: String?) -> ())?,
        fromViewController: UIViewController
        )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        var promptTextField: UITextField?
        if let placeholder = textFieldPlaceholder {
            alert.addTextField { textField in
                textField.placeholder = placeholder
                textField.text = textFieldDefault
                promptTextField = textField
            }
        }

        func handler(action: UIAlertAction!) {
            if let block = onButtonClicked {
                block(action.title, promptTextField?.text)
            }
        }


        if let cancelButtonTitle = cancelButtonTitle {
            alert.addAction(UIAlertAction(
                title: cancelButtonTitle,
                style: .cancel,
                handler: handler
                ))
        }
        for otherTitle in otherButtonTitles ?? [] {
            alert.addAction(UIAlertAction(
                title: otherTitle,
                style: .default,
                handler: handler
                ))
        }

        fromViewController.present(alert, animated: true, completion: nil)
    }
}

#endif
