//
//  URL+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 3/27/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

/// Append path component to URL
public func /(lhs: URL, rhs: String) -> URL {
    return lhs.appendingPathComponent(rhs)
}

extension URL {
    /// Copy removing the query
    public var deletingQuery: URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.query = nil
        return components.url ?? self
    }

    /// Copy with HTTPS scheme
    public var https: URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.scheme = "https"
        return components.url ?? self
    }

    /// Get the components that don't match the given other URL
    ///
    /// For example:
    /// http://drewag.me/one/two/three compared to http://drewag.me/one/other/three
    /// will result in ["two","three"] because "/one" matches but then the paths
    /// start to differ.
    public func pathComponents(differentFrom URL: URL) -> [String] {
        let left = self.resolvingSymlinksInPath().pathComponents
        let right = URL.resolvingSymlinksInPath().pathComponents

        var components = [String]()
        for i in 0 ..< left.count {
            guard i < right.count, components.isEmpty else {
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
