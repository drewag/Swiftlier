//
//  Transformation.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/17/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public struct Transform {
    public var rotation: Angle<CGFloat>
    public var scale: CGFloat
    public var translation: CGPoint

    public init(translation: CGPoint = CGPoint(), scale: CGFloat = 1, rotation: Angle<CGFloat> = Angle.zero) {
        self.rotation = rotation
        self.scale = scale
        self.translation = translation
    }

   #if os(iOS)
    public var affineTransform: CGAffineTransform {
        var transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        transform = transform.translatedBy(x: self.translation.x, y: self.translation.y)
        transform = transform.rotated(by: CGFloat(self.rotation.radians))
        return transform
    }
    #endif
}

#if os(iOS)
import UIKit

public extension UIView {
    func set(transform: Transform) {
        self.transform = transform.affineTransform
    }
}
#endif
