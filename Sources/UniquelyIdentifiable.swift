//
//  File.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 10/5/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

public protocol RawIdentifiable {
    var rawIdentifier: String {get}
}

public protocol UniquelyIdentifiable: RawIdentifiable {
    var id: UUID {get}
}

extension UniquelyIdentifiable {
    public var rawIdentifier: String {
        return self.id.uuidString
    }
}

