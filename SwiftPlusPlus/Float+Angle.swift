//
//  Float+Angle.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/3/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension Float {
    public var toRadians: Float {
        return self * Float(M_PI) / 180.0
    }

    public var toDegrees: Float {
        return self * 180.0 / Float(M_PI)
    }
}
