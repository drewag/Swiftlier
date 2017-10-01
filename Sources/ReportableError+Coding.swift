//
//  ReportableError+Encoding.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/15/17.
//
//

extension ErrorPerpitrator {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = ErrorPerpitrator(rawValue: try container.decode(String.self)) ?? .system
    }

    public func encode(_ encoder: Encoder)  throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }
}

enum ReportableErrorCodingKeys: String, CodingKey {
    case message, doing, because, perpitrator
}

extension ReportableError {
    public func encodeStandard(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ReportableErrorCodingKeys.self)
        try container.encode(self.description, forKey: .message)
        try container.encode(self.doing, forKey: .doing)
        try container.encode(self.reason.because, forKey: .because)
        try container.encode(self.perpetrator, forKey: .perpitrator)
    }
}

