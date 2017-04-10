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

extension URL {
    public func deletingQuery() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.query = nil
        return components.url ?? self
    }
}
