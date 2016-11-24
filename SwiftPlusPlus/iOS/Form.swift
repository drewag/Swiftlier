//
//  Form.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/17/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

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
    var isSecureEntry: Bool {get}
    var placeholder: String {get}

    func update(with string: String)
}

public struct Form {
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
        public let helpURL: NSURL?
        public let fields: OrderedDictionary<String, Field>

        public init(name: String, help: String? = nil, helpURL: NSURL? = nil, build: (inout Builder) -> ()) {
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
                    throw LocalUserReportableError(source: "FormViewController", operation: "updating account information", message: "\(field.label) is not valid", type: .User)
                case .failedWithReason(let reason):
                    throw LocalUserReportableError(source: "FormViewController", operation: "updating account information", message: "\(field.label) \(reason)", type: .User)
                }
            }
        }
    }
}

public class EmailField: SimpleField {
    public typealias Value = String

    public let label: String
    public let placeholder: String
    public let keyboard = UIKeyboardType.EmailAddress
    public let isSecureEntry = false
    public let isRequired: Bool
    public let autoCapitalize = UITextAutocapitalizationType.None
    public let originalValue: String
    public var value: String

    public init(label: String = "Email", placeholder: String = "email@example.com", isRequired: Bool = false, value: String) {
        self.label = label
        self.placeholder = placeholder
        self.originalValue = value
        self.value = value
        self.isRequired = isRequired
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
    public let keyboard = UIKeyboardType.Default
    public let isSecureEntry = false
    public let isRequired: Bool
    public let autoCapitalize = UITextAutocapitalizationType.Words
    public let originalValue: String
    public var value: String

    public init(label: String, placeholder: String = "", isRequired: Bool = false, value: String) {
        self.label = label
        self.placeholder = placeholder
        self.originalValue = value
        self.value = value
        self.isRequired = isRequired
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
    public let keyboard = UIKeyboardType.Default
    public let isSecureEntry = true
    public let isRequired: Bool
    public let autoCapitalize = UITextAutocapitalizationType.Words
    public let originalValue: String
    public var value: String = ""

    public init(label: String = "Password", isRequired: Bool = false, placeholder: String = "•••••••••••••") {
        self.label = label
        self.placeholder = placeholder
        self.originalValue = value
        self.isRequired = isRequired
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
    public let keyboard = UIKeyboardType.NumberPad
    public let isSecureEntry = false
    public let autoCapitalize = UITextAutocapitalizationType.None
    public let isRequired: Bool
    public let originalValue: Int?
    public let minimumValue: Int
    public let maximumValue: Int
    public let unit: String?
    public var value: Int?

    public convenience init(label: String, placeholder: String, value: String?, isRequired: Bool = false, unit: String? = nil, minimum: Int = 0, maximum: Int = Int.max) {
        var intValue: Int? = nil
        if let value = value {
            intValue = Int(value)
        }
        self.init(
            label: label,
            placeholder: placeholder,
            value: intValue,
            unit: unit,
            minimum: minimum,
            maximum: maximum
        )
    }

    public init(label: String, placeholder: String, value: Int?, isRequired: Bool = false, unit: String? = nil, minimum: Int = 0, maximum: Int = Int.max) {
        self.label = label
        self.placeholder = placeholder
        self.value = value
        self.originalValue = value
        self.minimumValue = minimum
        self.maximumValue = maximum
        self.unit = unit
        self.isRequired = isRequired
    }

    public var displayValue: String {
        if let unit = self.unit {
            return "\(self.value) \(unit)"
        }
        return self.value?.description ?? ""
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
