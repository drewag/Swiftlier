//
//  SwiftlierResult.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/31/19.
//

import Foundation

public enum SwiftlierResult<Success> {
    case success(Success)
    case failure(SwiftlierError)
}
