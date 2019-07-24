//
//  Double+Formatting.swift
//  OnBeatCore
//
//  Created by Andrew J Wagner on 11/3/16.
//
//

import Foundation

extension Double {
    public var asPercent: String {
        let after = Int((self * 100).rounded())
        return "\(after)%"
    }
}
