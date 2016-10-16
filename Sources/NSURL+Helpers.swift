//
//  NSURL+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/28/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension URL {
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
