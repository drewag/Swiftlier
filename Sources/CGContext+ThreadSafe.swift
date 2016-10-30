//
//  CGContext+ThreadSafe.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 8/26/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

// A collection of properties and methods to replace the built in UIGraphics functions
// that work off of the graphic context stack. The stack is not reliable when trying to
// draw from multiple threads at once. These properties and methods work directly off the
// context so you don't have to worry what is currently on the stack.

import Foundation

#if os(iOS)
import UIKit

extension CGContext {
    public var image: UIImage? {
        guard let CGImage = self.makeImage() else {
            return nil
        }
        return UIImage(cgImage: CGImage)
    }

    public func draw(_ image: UIImage?, inRect rect: CGRect) {
        guard let image = image else {
            return
        }
        self.draw(image, inRect: rect)
    }

    public func draw(_ image: CGImage?, inRect rect: CGRect) {
        guard let image = image else {
            return
        }

        self.saveGState()
        self.translateBy(x: 0, y: rect.height)
        self.scaleBy(x: 1.0, y: -1.0)

        self.draw(image, in: rect)

        self.restoreGState()
    }

    public static func createImageContext(withSize size: CGSize, coordinateSystem: CoordinateSystem = .uiKit) -> CGContext? {
        let scale: CGFloat
        switch coordinateSystem {
        case .uiKit:
            scale = UIScreen.main.scale
        case .pdf:
            scale = 1
        }
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: nil,
            width: Int(size.width * scale),
            height: Int(size.height * scale),
            bitsPerComponent: 8,
            bytesPerRow: Int(size.width * scale * 4),
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )!

        switch coordinateSystem {
        case .uiKit:
            context.translateBy(x: 0, y: size.height * scale);
            context.scaleBy(x: scale, y: -scale)
        case .pdf:
            break
        }

        return context
    }
}

public enum CoordinateSystem {
    case uiKit
    case pdf
}
#endif
