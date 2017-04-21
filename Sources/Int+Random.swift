//
//  Int+Random.swift
//  web
//
//  Created by Andrew J Wagner on 4/20/17.
//
//


import Foundation

extension Int {
    public init(randomIn range: Range<Int>) {
        #if os(Linux)
            self = Int(random()) % range.count + range.lowerBound
        #else
            self = Int(arc4random_uniform(UInt32(range.count))) + range.lowerBound
        #endif
    }

    public init(randomIn range: ClosedRange<Int>) {
        #if os(Linux)
            self = Int(random()) % range.count + range.lowerBound
        #else
            self = Int(arc4random_uniform(UInt32(range.count))) + range.lowerBound
        #endif
    }

    public init(randomOfLength length: Int) {
        self.init(randomIn: Int(pow(10, Double(length - 1))) ..< Int(pow(10, Double(length))))
    }
}
