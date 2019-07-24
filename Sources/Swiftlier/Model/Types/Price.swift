//
//  Price.swift
//  web
//
//  Created by Andrew J Wagner on 4/23/17.
//
//

import Foundation

public struct Price: CustomStringConvertible {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.currencySymbol = ""

        return formatter
    }()

    enum Value {
        case pennies(Int)
        case dollars(Double)
    }

    private let value: Value

    public init(pennies: Int) {
        self.value = .pennies(pennies)
    }

    public init(dollars: Double) {
        self.value = .dollars(dollars)
    }

    public var pennies: Int {
        switch self.value {
        case .pennies(let pennies):
            return pennies
        case .dollars(let dollars):
            return Int(round(dollars * 100))
        }
    }

    public var dollars: Double {
        switch self.value {
        case .pennies(let pennies):
            return Double(pennies) / 100
        case .dollars(let dollars):
            return dollars
        }
    }

    public var description: String {
        return Price.currencyFormatter.string(for: self.dollars) ?? "NA"
    }
}
