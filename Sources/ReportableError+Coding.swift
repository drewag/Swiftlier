//
//  ReportableError+Encoding.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/15/17.
//
//

internal struct ReportableErrorKeys {
    class message: CoderKey<String> {}
    class doing: OptionalCoderKey<String> {}
    class because: OptionalCoderKey<String> {}
    class perpitrator: OptionalCoderKey<ErrorPerpitrator> {}
}

extension ErrorPerpitrator {
    public init(decoder: Decoder) throws {
        self = ErrorPerpitrator(rawValue: try decoder.decodeAsEntireValue()) ?? .system
    }

    public func encode(_ encoder: Encoder) {
        encoder.encodeAsEntireValue(self.rawValue)
    }
}

extension ReportableError {
    public func encodeStandard(_ encoder: Encoder) {
        encoder.encode(self.description, forKey: ReportableErrorKeys.message.self)
        encoder.encode(self.doing, forKey: ReportableErrorKeys.doing.self)
        encoder.encode(self.reason.because, forKey: ReportableErrorKeys.because.self)
        encoder.encode(self.perpetrator, forKey: ReportableErrorKeys.perpitrator.self)
    }
}
