//
//  URL+Helpers.swift
//  Swiftlier
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

    public func https() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.scheme = "https"
        return components.url ?? self
    }

    public func pathComponents(differentFrom URL: URL) -> [String] {
        let left = self.resolvingSymlinksInPath().pathComponents
        let right = URL.resolvingSymlinksInPath().pathComponents

        var components = [String]()
        for i in 0 ..< left.count {
            guard i < right.count else {
                components.append(left[i])
                continue
            }

            guard left[i] != right[i] else {
                continue
            }

            components.append(left[i])
        }
        return components
    }
}
