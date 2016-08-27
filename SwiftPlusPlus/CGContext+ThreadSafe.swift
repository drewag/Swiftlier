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
extension CGContext {
    public var CGImage: CGImageRef? {
        return CGBitmapContextCreateImage(self)
    }

    public var image: UIImage? {
        guard let CGImage = self.CGImage else {
            return nil
        }
        return UIImage(CGImage: CGImage)
    }

    public func draw(image: UIImage?, inRect rect: CGRect) {
        self.draw(image?.CGImage, inRect: rect)
    }

    public func draw(image: CGImageRef?, inRect rect: CGRect) {
        guard let image = image else {
            return
        }

        CGContextSaveGState(self)
        CGContextTranslateCTM(self, 0, rect.height);
        CGContextScaleCTM(self, 1.0, -1.0);

        CGContextDrawImage(self, rect, image)

        CGContextRestoreGState(self)
    }

    public static func createImageContext(withSize size: CGSize) -> CGContext? {
        let scale = UIScreen.mainScreen().scale
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGBitmapContextCreate(
            nil,
            Int(size.width * scale),
            Int(size.height * scale),
            8,
            Int(size.width * scale * 4),
            colorSpace,
            bitmapInfo.rawValue
        )

        CGContextTranslateCTM(context, 0, size.height * scale);
        CGContextScaleCTM(context, scale, -scale)

        return context
    }
}