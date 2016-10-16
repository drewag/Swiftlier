//
//  UIView+ImageCapture.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/10/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    func captureImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 1)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
#endif
