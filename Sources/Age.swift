//
//  Age.swift
//  web
//
//  Created by Andrew J Wagner on 3/1/17.
//
//

import Foundation

public struct Age {
    public let years: Int

    public init(date: Date) {
        #if os(Linux)
            let seconds = Date().timeIntervalSince1970 - date.timeIntervalSince1970
            self.years = Int(seconds / 365 / 24 / 60 / 60)
        #else
            let components = Calendar.current.dateComponents(
                Set([Calendar.Component.year]),
                from: date,
                to: Date()
            )
            self.years = components.year!
        #endif
    }
}

extension Age: Codable {
    struct Keys {
        class years: CoderKey<Int> {}
    }

    public init(decoder: Decoder) throws {
        self.years = try decoder.decode(Keys.years.self)
    }

    public func encode(_ encoder: Encoder) {
        encoder.encode(self.years, forKey: Keys.years.self)
    }
}
