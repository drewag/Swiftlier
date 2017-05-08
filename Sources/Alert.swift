//
//  Alert.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 9/10/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)

import UIKit
import ObjectiveC

var MakeAlertAction: (String?, UIAlertActionStyle, ((UIAlertAction) -> Swift.Void)?) -> UIAlertAction = UIAlertAction.init

public class ErrorOccured: EventType { public typealias CallbackParam = ReportableError }

class Alert: NSObject {
    private let onButtonClicked: (_ buttonTitle: String?, _ textFieldText: String?) -> ()

    private init(onButtonClicked: @escaping (_ buttonTitle: String?, _ textFieldText: String?) -> ()) {
        self.onButtonClicked = onButtonClicked

        super.init()
    }
}

protocol AnyAlertAction {
    var name: String {get}
    var isDestructive: Bool {get}
}

public final class AlertAction: AnyAlertAction {
    let name: String
    let isDestructive: Bool
    let handler: (() -> ())?

    init(name: String, isDestructive: Bool = false, handler: (() -> ())?) {
        self.name = name
        self.isDestructive = isDestructive
        self.handler = handler
    }

    public static func action(_ name: String, isDestructive: Bool = false, handler: (() -> ())? = nil) -> AlertAction {
        return AlertAction(name: name, isDestructive: isDestructive, handler: handler)
    }
}

public final class TextAction: AnyAlertAction {
    let name: String
    let isDestructive: Bool
    let handler: ((_ text: String) -> ())?

    init(name: String, isDestructive: Bool = false, handler: ((_ text: String) -> ())?) {
        self.name = name
        self.isDestructive = isDestructive
        self.handler = handler
    }

    public static func action(_ name: String, isDestructive: Bool = false, handler: ((_ text: String) -> ())? = nil) -> TextAction {
        return TextAction(name: name, isDestructive: isDestructive, handler: handler)
    }
}

extension ErrorGenerating where Self: UIViewController {
    public func showAlert(
        withError error: Error,
        _ doing: String,
        other: [AlertAction] = []
        )
    {
        let error = self.error(doing, from: error).byUserIfBecauseOf([
            NetworkResponseErrorReason.noInternet,
            NetworkResponseErrorReason.unauthorized,
            NetworkResponseErrorReason.gone,
        ])
        EventCenter.defaultCenter().triggerEvent(ErrorOccured.self, params: error)
        self.showAlert(
            withTitle: error.alertDescription.title,
            message: error.alertDescription.message,
            other: other
        )
    }
}

extension UIViewController {
    public func showAlert(
        withError error: ReportableError,
        other: [AlertAction] = []
        )
    {
        let error = error.byUserIfBecauseOf([
            NetworkResponseErrorReason.noInternet,
            NetworkResponseErrorReason.unauthorized,
            NetworkResponseErrorReason.gone,
        ])
        EventCenter.defaultCenter().triggerEvent(ErrorOccured.self, params: error)
        self.showAlert(
            withTitle: error.alertDescription.title,
            message: error.alertDescription.message,
            other: other
        )
    }

    public func showActionSheet(
        withTitle title: String,
        message: String? = nil,
        cancel: AlertAction? = nil,
        preferred: AlertAction? = nil,
        other: [AlertAction] = []
        )
    {
        var other = other
        if cancel == nil && other.isEmpty {
            other.append(.action("OK"))
        }

        let alert = Alert.buildAlert(
            withTitle: title,
            message: message,
            style: .actionSheet,
            cancel: cancel,
            preferred: preferred,
            other: other,
            onTapped: { tappedAction in
                if let action = cancel, action.name == tappedAction.title {
                    action.handler?()
                    return
                }
                if let preferred = preferred, preferred.name == tappedAction.title {
                    preferred.handler?()
                    return
                }
                for action in other {
                    if action.name == tappedAction.title {
                        action.handler?()
                        return
                    }
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }

    public func showAlert(
        withTitle title: String,
        message: String,
        cancel: AlertAction? = nil,
        preferred: AlertAction? = nil,
        other: [AlertAction] = []
        )
    {
        var other = other
        if cancel == nil && other.isEmpty {
            other.append(.action("OK"))
        }

        let alert = Alert.buildAlert(
            withTitle: title,
            message: message,
            style: .alert,
            cancel: cancel,
            preferred: preferred,
            other: other,
            onTapped: { tappedAction in
                if let action = cancel, action.name == tappedAction.title {
                    action.handler?()
                    return
                }
                if let preferred = preferred, preferred.name == tappedAction.title {
                    preferred.handler?()
                    return
                }
                for action in other {
                    if action.name == tappedAction.title {
                        action.handler?()
                        return
                    }
                }
            }
        )
        self.present(alert, animated: true, completion: nil)
    }

    public func showTextInput(
        withTitle title: String,
        message: String,
        textFieldPlaceholder: String = "",
        textFieldDefault: String? = nil,
        keyboardType: UIKeyboardType = .default,
        cancel: TextAction? = nil,
        preferred: TextAction? = nil,
        other: [TextAction] = []
        )
    {
        var other = other
        if cancel == nil && other.isEmpty {
            other.append(.action("OK"))
        }

        var promptTextField: UITextField?
        let alert = Alert.buildAlert(
            withTitle: title,
            message: message,
            style: .alert,
            cancel: cancel,
            preferred: preferred,
            other: other,
            onTapped: { tappedAction in
                if let action = cancel, action.name == tappedAction.title {
                    action.handler?(promptTextField?.text ?? "")
                    return
                }
                if let preferred = preferred, preferred.name == tappedAction.title {
                    preferred.handler?(promptTextField?.text ?? "")
                    return
                }
                for action in other {
                    if action.name == tappedAction.title {
                        action.handler?(promptTextField?.text ?? "")
                        return
                    }
                }
            }
        )

        alert.addTextField { textField in
            textField.placeholder = textFieldPlaceholder
            textField.text = textFieldDefault
            textField.keyboardType = keyboardType
            promptTextField = textField
        }
        self.present(alert, animated: true, completion: nil)
    }
}

private extension Alert {
    struct Keys {
        static var Delegate = "Delegate"
    }

    class func buildAlert(
        withTitle title: String,
        message: String?,
        style: UIAlertControllerStyle,
        cancel: AnyAlertAction? = nil,
        preferred: AnyAlertAction? = nil,
        other: [AnyAlertAction] = [],
        onTapped: @escaping (UIAlertAction) -> ()
        ) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)

        if let cancel = cancel {
            alert.addAction(MakeAlertAction(
                cancel.name,
                .cancel,
                onTapped
            ))
        }

        if let preferred = preferred {
            let action = MakeAlertAction(
                preferred.name,
                preferred.isDestructive ? .destructive : .default,
                onTapped
            )
            alert.addAction(action)
            alert.preferredAction = action
        }

        for action in other {
            alert.addAction(MakeAlertAction(
                action.name,
                action.isDestructive ? .destructive : .default,
                onTapped
            ))
        }

        return alert
    }
}

#endif
