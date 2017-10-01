//
//  TestCodable.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 4/27/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Swiftlier

struct TestCodable: Codable {
    let string: String
    let int: Int
}

class TestReferenceCodable: Codable {
    let string: String
    let int: Int

    init(string: String, int: Int) {
        self.string = string
        self.int = int
    }
}
