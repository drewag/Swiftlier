//
//  Array+SwiftPlusPlus.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/1/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension Array {
    public mutating func insert(_ element: Element, assumingAlreadySortedWithSort isOrderedBefore: (Element, Element) -> (Bool)) -> Int {
        for i in 0 ..< self.count {
            if !isOrderedBefore(self[i], element) {
                self.insert(element, at: i)
                return i
            }
        }
        self.append(element)
        return self.count - 1
    }
}
