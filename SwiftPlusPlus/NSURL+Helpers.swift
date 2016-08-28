//
//  NSURL+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/28/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

extension NSURL {
    public func pathComponents(differentFrom URL: NSURL) -> [String] {
        let left = self.URLByResolvingSymlinksInPath!.pathComponents ?? []
        let right = URL.URLByResolvingSymlinksInPath!.pathComponents ?? []

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