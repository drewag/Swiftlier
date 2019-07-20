//
//  LimitedQueue.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/19/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

import Foundation

public struct LimitedQueue<Element> {
    private let limit: Int
    public private(set) var elements = [Element]()

    public init(limit: Int) {
        self.limit = limit
    }

    public mutating func push(_ element: Element) {
        self.elements.append(element)
        while self.elements.count > self.limit {
            self.elements.removeFirst()
        }
    }

    public mutating func removeAll() {
        self.elements.removeAll()
    }
}
