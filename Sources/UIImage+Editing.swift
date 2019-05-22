//
//  UIImage+Editing.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 5/25/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public enum ImageResizeMode {
    case aspectFit
    case aspectFill
}

extension UIImage {
    public func resizeImage(toSize size:CGSize, withMode mode: ImageResizeMode, andScale scale: CGFloat = 0) -> UIImage {
        var scaledImageRect = CGRect()

        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight: CGFloat = size.height / self.size.height
        let aspectRatio: CGFloat
        switch mode {
        case .aspectFill:
            aspectRatio = max(aspectWidth, aspectHeight)
        case .aspectFit:
            aspectRatio = min(aspectWidth, aspectHeight)
        }

        scaledImageRect.size.width = round(self.size.width * aspectRatio)
        scaledImageRect.size.height = round(self.size.height * aspectRatio)

        switch mode {
        case .aspectFill:
            scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
            scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
        case .aspectFit:
            UIGraphicsBeginImageContextWithOptions(scaledImageRect.size, false, scale)
        }

        self.draw(in: scaledImageRect)

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }

    public var normalized: UIImage {
        guard self.imageOrientation != .up
            , let cgImage = self.cgImage
            , let colorSpace = cgImage.colorSpace
            else
        {
            return self
        }

        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi/2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi/2)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let ctx = CGContext(
                data: nil,
                width: Int(self.size.width),
                height: Int(self.size.height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: UInt32(self.cgImage!.bitmapInfo.rawValue)
            )
            else
        {
            return self
        }

        ctx.concatenate(transform)

        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height:self.size.width))
        default:
            ctx.draw(cgImage, in: CGRect(x:0, y: 0, width: self.size.width, height:self.size.height))
        }

        // And now we just create a new UIImage from the drawing context
        guard let cgimg = ctx.makeImage() else {
            return self
        }

        return UIImage(cgImage: cgimg)
    }

    public func desaturated(brightness: CGFloat = 0.7) -> UIImage {
        guard let currentCGImage = self.cgImage else { return self }

        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")

        // set a gray value for the tint color
        filter?.setValue(CIColor(red: brightness, green: brightness, blue: brightness), forKey: "inputColor")

        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return self }

        let context = CIContext()

        guard let cgimg = context.createCGImage(outputImage, from: outputImage.extent) else { return self }

        return UIImage(cgImage: cgimg)
    }
}
#endif
