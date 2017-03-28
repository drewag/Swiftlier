//
//  URL+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 3/27/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

public func /(lhs: URL, rhs: String) -> URL {
    return lhs.appendingPathComponent(rhs)
}
