//
//  TestCodable.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/27/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Swiftlier

struct TestCodable {
    let string: String
    let int: Int
}

extension TestCodable: Codable {
    struct Keys {
        class string: CoderKey<String> {}
        class int: CoderKey<Int> {}
    }

    init(decoder: Decoder) throws {
        self.string = try decoder.decode(Keys.string.self)
        self.int = try decoder.decode(Keys.int.self)
    }

    func encode(_ encoder: Encoder) {
        encoder.encode(self.string, forKey: Keys.string.self)
        encoder.encode(self.int, forKey: Keys.int.self)
    }
}
