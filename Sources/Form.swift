//
//  Form.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 11/17/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public protocol FieldValueType: Equatable {
}
extension String: FieldValueType {}
extension Int: FieldValueType {}
extension Double: FieldValueType {}

public enum ValidationResult {
    case passed
    case failed
    case failedWithReason(String)
}


public protocol Field: class {
    var label: String {get}
    var displayValue: String {get}
    func validate() -> ValidationResult
}

public protocol SimpleField: Field {
    var keyboard: UIKeyboardType { get}
    var autoCapitalize: UITextAutocapitalizationType {get}
    var autoCorrect: Bool {get}
    var isSecureEntry: Bool {get}
    var placeholder: String {get}

    func update(with string: String)
}

public struct Form: ErrorGenerating {
    public struct Builder {
        var sections = OrderedDictionary<String, Section>()

        public subscript(name: String) -> Section? {
            get {
                return self.sections[name]
            }
            set {
                self.sections[name] = newValue
            }
        }
    }

    public struct Section {
        public struct Builder {
            var fields = OrderedDictionary<String, Field>()

            public subscript(name: String) -> Field? {
                get {
                    return self.fields[name]
                }
                set {
                    self.fields[name] = newValue
                }
            }
        }

        public let name: String
        public let help: String?
        public let helpURL: URL?
        public let fields: OrderedDictionary<String, Field>

        public init(name: String, help: String? = nil, helpURL: URL? = nil, build: (inout Builder) -> ()) {
            self.name = name
            self.help = help
            self.helpURL = helpURL
            var builder = Builder()
            build(&builder)
            self.fields = builder.fields
        }
    }

    public var sections: OrderedDictionary<String, Section>

    public init(build: (inout Builder) -> ()) {
        var builder = Builder()
        build(&builder)
        self.sections = builder.sections
    }

    public func validate() throws {
        for section in self.sections.values {
            for field in section.fields.values {
                let result = field.validate()
                switch result {
                case .passed:
                    continue
                case .failed:
                    throw self.userError("saving", because: "\(field.label) is not valid")
                case .failedWithReason(let reason):
                    throw self.userError("saving", because: "\(field.label) \(reason)")
                }
            }
        }
    }
}

public class DisplayOnlyField: Field {
    public let label: String
    public var value: String

    public init(label: String = "Email", value: String) {
        self.label = label
        self.value = value
    }

    public var displayValue: String {
        return value
    }

    public func validate() -> ValidationResult {
        return .passed
    }
}

public class EmailField: SimpleField {
    public typealias Value = String

    public let label: String
    public let placeholder: String
    public let keyboard = UIKeyboardType.emailAddress
    public let isSecureEntry = false
    public let isRequired: Bool
    public let autoCapitalize = UITextAutocapitalizationType.none
    public let autoCorrect: Bool
    public let originalValue: String
    public var value: String

    public init(label: String = "Email", placeholder: String = "email@example.com", isRequired: Bool = false, autoCorrect: Bool = false, value: String) {
        self.label = label
        self.placeholder = placeholder
        self.originalValue = value
        self.value = value
        self.isRequired = isRequired
        self.autoCorrect = autoCorrect
    }

    public var displayValue: String {
        return self.value
    }

    public func update(with string: String) {
        self.value = string
    }

    public func validate() -> ValidationResult {
        guard self.value != "" else {
            return .failedWithReason("must not be empty")
        }
        guard self.value.isValidEmail else {
            return .failedWithReason("is not a valid email")
        }
        return .passed
    }
}

public class NameField: SimpleField {
    public let label: String
    public let placeholder: String
    public let keyboard = UIKeyboardType.default
    public let isSecureEntry = false
    public let isRequired: Bool
    public let autoCapitalize = UITextAutocapitalizationType.words
    public let autoCorrect: Bool
    public let originalValue: String
    public var value: String

    public init(label: String, placeholder: String = "", isRequired: Bool = false, autoCorrect: Bool = false, value: String) {
        self.label = label
        self.placeholder = placeholder
        self.originalValue = value
        self.value = value
        self.isRequired = isRequired
        self.autoCorrect = autoCorrect
    }

    public var displayValue: String {
        return self.value
    }

    public func update(with string: String) {
        self.value = string
    }

    public func validate() -> ValidationResult {
        guard self.value != "" || !self.isRequired else {
            return .failedWithReason("must not be empty")
        }
        return .passed
    }
}

public class PasswordField: SimpleField {
    public let label: String
    public let placeholder: String
    public let keyboard = UIKeyboardType.default
    public let isSecureEntry = true
    public let isRequired: Bool
    public let autoCapitalize = UITextAutocapitalizationType.words
    public let autoCorrect: Bool
    public let originalValue: String
    public var value: String = ""

    public init(label: String = "Password", isRequired: Bool = false, autoCorrect: Bool = false, placeholder: String = "•••••••••••••") {
        self.label = label
        self.placeholder = placeholder
        self.originalValue = value
        self.isRequired = isRequired
        self.autoCorrect = autoCorrect
    }

    public var displayValue: String {
        return self.value
    }

    public func update(with string: String) {
        self.value = string
    }

    public func validate() -> ValidationResult {
        guard self.value != "" || !self.isRequired else {
            return .failedWithReason("must not be empty")
        }
        return .passed
    }
}

public class IntegerField: SimpleField {
    public let label: String
    public let placeholder: String
    public let keyboard = UIKeyboardType.numberPad
    public let isSecureEntry = false
    public let autoCapitalize = UITextAutocapitalizationType.none
    public let autoCorrect: Bool
    public let isRequired: Bool
    public let originalValue: Int?
    public let minimumValue: Int
    public let maximumValue: Int
    public let formatter: Formatter?
    public var value: Int?

    public convenience init(label: String, placeholder: String, value: String?, isRequired: Bool = false, formatter: Formatter? = nil, minimum: Int = 0, maximum: Int = Int.max) {
        var intValue: Int? = nil
        if let value = value {
            intValue = Int(value)
        }
        self.init(
            label: label,
            placeholder: placeholder,
            value: intValue,
            formatter: formatter,
            minimum: minimum,
            maximum: maximum
        )
    }

    public init(label: String, placeholder: String, value: Int?, isRequired: Bool = false, autoCorrect: Bool = false, formatter: Formatter? = nil, minimum: Int = 0, maximum: Int = Int.max) {
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.originalValue = value
        self.minimumValue = minimum
        self.maximumValue = maximum
        self.formatter = formatter
        self.isRequired = isRequired
        self.autoCorrect = autoCorrect
    }

    public var displayValue: String {
        guard let value = self.value else {
            return ""
        }
        if let formatter = self.formatter,
            let string = formatter.string(for: value)
        {
            return string
        }
        return value.description
    }

    public func update(with string: String) {
        self.value = Int(string)
    }

    public func validate() -> ValidationResult {
        guard let value = self.value else {
            if self.isRequired {
                return .failedWithReason("is required")
            }
            else {
                return .passed
            }
        }

        guard value >= self.minimumValue && value <= self.maximumValue else {
            return .failedWithReason("must be between \(self.minimumValue) and \(self.maximumValue)")
        }

        return .passed
    }
}

public class BoolField: Field {
    public let label: String
    public var value: Bool

    public init(label: String, value: Bool) {
        self.label = label
        self.value = value
    }

    public var displayValue: String {
        return self.value ? "Yes" : "No"
    }

    public func validate() -> ValidationResult {
        return .passed
    }
}

public class DateField: Field {
    public let label: String
    public var value: Date
    public let includesDay: Bool

    public init(label: String, value: Date, includesDay: Bool = true) {
        self.label = label
        self.value = value
        self.includesDay = includesDay
    }

    public var displayValue: String {
        if self.includesDay {
            return self.value.shortDate
        }
        else {
            return self.value.monthAndYear
        }
    }

    public func validate() -> ValidationResult {
        return .passed
    }
}

public class SelectField: Field {
    public let label: String
    public var value: String
    public var options: [String]

    public init(label: String, value: String, options: [String]) {
        self.label = label
        self.value = value
        self.options = options
    }

    public var displayValue: String {
        return self.value
    }

    public func validate() -> ValidationResult {
        return .passed
    }
}

public class CustomViewControllerField: Field {
    public let label: String

    let buildViewController: (_ setValue: @escaping (String?) -> ()) -> (UIViewController)
    let isRequired: Bool
    let isEditable: Bool
    let canBeCleared: Bool
    public var value: String?

    public init(label: String, value: String?, isRequired: Bool = false, isEditable: Bool = true, canBeCleared: Bool = false, build: @escaping (_ setValue: @escaping (String?) -> ()) -> (UIViewController)) {
        self.label = label
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.canBeCleared = canBeCleared
        self.buildViewController = build
        self.value = value
    }

    public var displayValue: String {
        return self.value ?? ""
    }

    public func validate() -> ValidationResult {
        guard let value = self.value, !value.isEmpty else {
            if self.isRequired {
                return .failedWithReason("is required")
            }
            else {
                return .passed
            }
        }
        return .passed
    }
}

public class ActionField: Field {
    public let label: String
    let block: () -> ()

    public init(label: String, block: @escaping () -> ()) {
        self.label = label
        self.block = block
    }

    public var displayValue: String {
        return ""
    }

    public func validate() -> ValidationResult {
        return .passed
    }
}

#endif
