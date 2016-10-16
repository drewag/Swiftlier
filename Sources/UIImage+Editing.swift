//
//  UIImage+Editing.swift
//  SwiftPlusPlus
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
    public func resizeImage(toSize size:CGSize, withMode mode: ImageResizeMode) -> UIImage {
        var scaledImageRect = CGRect.zero

        let aspectWidth: CGFloat = size.width / self.size.width
        let aspectHeight: CGFloat = size.height / self.size.height
        let aspectRatio: CGFloat
        switch mode {
        case .aspectFill:
            aspectRatio = max(aspectWidth, aspectHeight)
        case .aspectFit:
            aspectRatio = max(aspectWidth, aspectHeight)
        }

        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0

        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        self.draw(in: scaledImageRect)

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage!
    }
}
#endif
