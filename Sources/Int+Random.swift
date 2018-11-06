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
	self = Int.random(in: range)
    }

    public init(randomIn range: ClosedRange<Int>) {
	self = Int.random(in: range)
    }

    public init(randomOfLength length: Int) {
        self.init(randomIn: Int(pow(10, Double(length - 1))) ..< Int(pow(10, Double(length))))
    }
}
