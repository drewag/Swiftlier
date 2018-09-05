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
