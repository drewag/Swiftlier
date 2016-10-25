//
//  UIImage+Editing.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/25/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import UIKit

public enum ImageResizeMode {
    case AspectFit
    case AspectFill
}

extension UIImage {
    public func resizeImage(toSize size:CGSize, withMode mode: ImageResizeMode) -> UIImage {
        var scaledImageRect = CGRect()

        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight: CGFloat = size.height / self.size.height
        let aspectRatio: CGFloat
        switch mode {
        case .AspectFill:
            aspectRatio = max(aspectWidth, aspectHeight)
        case .AspectFit:
            aspectRatio = min(aspectWidth, aspectHeight)
        }

        scaledImageRect.size.width = round(self.size.width * aspectRatio)
        scaledImageRect.size.height = round(self.size.height * aspectRatio)

        switch mode {
        case .AspectFill:
            scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
            scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
        case .AspectFit:
            UIGraphicsBeginImageContextWithOptions(scaledImageRect.size, false, 0)
        }

        self.drawInRect(scaledImageRect)

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
}
