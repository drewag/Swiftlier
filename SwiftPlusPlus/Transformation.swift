//
//  Transformation.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/17/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct Transform {
    public var rotation: Angle
    public var scale: CGFloat
    public var translation: CGPoint

    public init(translation: CGPoint = CGPoint(), scale: CGFloat = 1, rotation: Angle = Angle.zero) {
        self.rotation = rotation
        self.scale = scale
        self.translation = translation
    }

    public var affineTransform: CGAffineTransform {
        var transform = CGAffineTransformMakeScale(self.scale, self.scale)
        transform = CGAffineTransformTranslate(transform, self.translation.x, self.translation.y)
        transform = CGAffineTransformRotate(transform, self.rotation.radians())
        return transform
    }
}

#if os(iOS)
import UIKit

public extension UIView {
    func set(transform: Transform) {
        self.transform = transform.affineTransform
    }
}
#endif