//
//  CGMath.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/8/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS) || os(macOS)
import Foundation

extension CGPoint {
    public func angle(to point: CGPoint) -> Angle<CGFloat> {
        let x = point.x - self.x
        let y = point.y - self.y
        let angle = atan(abs(y) / abs(x))
        switch (x >= 0, y >= 0) {
        case (true, true):
            return Angle(radians: angle)
        case (false, true):
            return Angle(radians: .pi - angle)
        case (false, false):
            return Angle(radians: .pi + angle)
        case (true, false):
            return Angle(radians: 2 * .pi - angle)
        }
    }

    public func centerBetween(_ otherPoint: CGPoint) -> CGPoint {
        return CGPoint(
            x: self.x + (otherPoint.x - self.x) / 2,
            y: self.y + (otherPoint.y - self.y) / 2
        )
    }

    public func distance(to point: CGPoint) -> CGFloat {
        let x = point.x - self.x
        let y = point.y - self.y
        return sqrt(pow(x, 2) + pow(y, 2))
    }
}


extension CGRect {
    public var aspectRatio: CGFloat {
        return self.width / self.height
    }

    public func aspectFittingRect(withAspectRatio ratio: CGFloat) -> CGRect {
        let width: CGFloat
        let height: CGFloat
        if self.aspectRatio < ratio {
            width = self.width
            height = self.width / ratio
        }
        else {
            width = self.height * ratio
            height = self.height
        }

        return CGRect(
            x: (self.width - width) / 2 + self.origin.x,
            y: (self.height - height) / 2 + self.origin.y,
            width: width,
            height: height
        )
    }

    public func aspectFillingRect(withAspectRatio ratio: CGFloat) -> CGRect {
        let width: CGFloat
        let height: CGFloat
        if self.aspectRatio < ratio {
            width = self.height * ratio
            height = self.height
        }
        else {
            width = self.width
            height = self.width * ratio
        }

        return CGRect(
            x: (self.width - width) / 2 + self.origin.x,
            y: (self.height - height) / 2 + self.origin.y,
            width: width,
            height: height
        )
    }
}

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func +=( lhs: inout CGPoint, rhs: CGPoint) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func -=( lhs: inout CGPoint, rhs: CGPoint) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

public func *(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
}

public func *=( lhs: inout CGPoint, rhs: CGPoint) {
    lhs.x *= rhs.x
    lhs.y *= rhs.y
}

public func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

public func /(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}
#endif
