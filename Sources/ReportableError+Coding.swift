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

