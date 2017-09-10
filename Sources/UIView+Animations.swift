//
//  UIView+Animations.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 9/9/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIView {
    public func shake(completion: ((Bool) -> ())? = nil) {
        let rotationDistance: CGFloat = 0.05
        UIView.animate(
            withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(rotationAngle: rotationDistance)
            },
            completion: { finished in
                guard finished else {
                    completion?(false)
                    return
                }
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.transform = CGAffineTransform(rotationAngle: -rotationDistance)
                    },
                    completion: { finished in
                        guard finished else {
                            completion?(false)
                            return
                        }
                        UIView.animate(
                            withDuration: 0.1,
                            animations: {
                                self.transform = CGAffineTransform.identity
                            },
                            completion: completion
                        )
                    }
                )
            }
        )
    }
}

#endif
