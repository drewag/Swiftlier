//
//  Age.swift
//  web
//
//  Created by Andrew J Wagner on 3/1/17.
//
//

public enum Age: Encodable {
    case Years(Int)

    public var years: Int {
        switch self {
        case .Years(let value):
            return value
        }
    }

    class SelfKey: CoderKey<Int> {}
    public init(decoder: Decoder) throws {
        self = Age.Years(try decoder.decode(SelfKey.self))
    }

    public func encode(_ encoder: Encoder) {
        encoder.encode(self.years, forKey: SelfKey.self)
    }
}
