//
//  EmailAddress.swift
//  web
//
//  Created by Andrew J Wagner on 4/22/17.
//
//

public struct EmailAddress: CustomStringConvertible {
    public let string: String

    public init(userString: String?, for purpose: String) throws {
        guard let string = userString?.trimmingWhitespaceOnEnds, !string.isEmpty else {
            throw GenericSwiftlierError(purpose, because: "an email is required", byUser: true)
        }

        guard string.isValidEmail else {
            throw GenericSwiftlierError(purpose, because: "'\(string)' is not a valid email. Please make sure you typed it correctly.", byUser: true)
        }

        self.string = string.lowercased()
    }

    public init(string: String?) throws {
        guard let string = string?.trimmingWhitespaceOnEnds, !string.isEmpty else {
            throw GenericSwiftlierError("creating email address", because: "email is required")
        }

        guard string.isValidEmail else {
            throw GenericSwiftlierError("creating email address", because: "'\(string)' is not a valid email")
        }

        self.string = string.lowercased()
    }

    public var description: String {
        return "Email(\(self.string))"
    }

    public var components: (user: String, domain: String) {
        var user = ""
        var domain = ""
        var beganDomain = false
        for character in self.string {
            guard !beganDomain else {
                domain.append(character)
                continue
            }
            switch character {
            case "@":
                beganDomain = true
            default:
                user.append(character)
            }
        }
        return (user: user, domain: domain)

    }

    public var domain: String {
        return self.components.domain
    }

    public var user: String {
        return self.components.user
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
