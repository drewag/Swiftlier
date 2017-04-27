//
//  Float+Angle.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/3/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension Float {
    public var toRadians: Float {
        return self * .pi / 180.0
    }

    public var toDegrees: Float {
        return self * 180.0 / .pi
    }
}
