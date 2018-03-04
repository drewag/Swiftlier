//
//  EmailAddress.swift
//  web
//
//  Created by Andrew J Wagner on 4/22/17.
//
//

public struct EmailAddress: CustomStringConvertible, ErrorGenerating {
    public let string: String

    public init(userString: String?, for purpose: String) throws {
        guard let string = userString?.trimmingWhitespaceOnEnds, !string.isEmpty else {
            throw EmailAddress.userError(purpose, because: "an email is required")
        }

        guard string.isValidEmail else {
            throw EmailAddress.userError(purpose, because: "that is not a valid email")
        }

        self.string = string.lowercased()
    }

    public init(string: String?) throws {
        guard let string = string?.trimmingWhitespaceOnEnds, !string.isEmpty else {
            throw EmailAddress.error("creating email address", because: "email is required")
        }

        guard string.isValidEmail else {
            throw EmailAddress.error("creating email address", because: "the email is invalid")
        }

        self.string = string.lowercased()
    }

    public var description: String {
        return "Email(\(self.string))"
    }

    public var domain: String {
        var output = ""
        var beganDomain = false
        for character in self.string {
            guard !beganDomain else {
                output.append(character)
                continue
            }
            switch character {
            case "@":
                beganDomain = true
            default:
                continue
            }
        }
        return output
    }
}

extension EmailAddress: Equatable {
    public static func ==(lhs: EmailAddress, rhs: EmailAddress) -> Bool {
        return lhs.string == rhs.string
    }
}

extension EmailAddress: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.string)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        try self.init(string: string)
    }
}

extension String {
    public var isValidEmail: Bool {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return self.range(of: emailRegEx, options: .regularExpression) != nil
    }
}
