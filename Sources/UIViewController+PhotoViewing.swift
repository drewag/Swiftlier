//
//  UIViewController+PhotoViewing.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

extension UIViewController {
    public func zoomToImage(in fromImageView: UIImageView) {
        guard let window = UIApplication.shared.keyWindow else {
            self.showAlert(withTitle: "Cannot Zoom To Image", message: "No window found")
            return
        }

        guard let image = fromImageView.image else {
            self.showAlert(withTitle: "Cannot Zoom To Image", message: "No image found")
            return
        }

        let imageAspectRatio = image.size.width / image.size.height

        fromImageView.image = nil

        let originalFrame = window.convert(fromImageView.bounds, from: fromImageView)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let imageViewClipView = self.createView(for: image, from: fromImageView, withFrame: originalFrame)
        let containerView = UIView()
        containerView.backgroundColor = UIColor(white: 0, alpha: 0)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let overlayImageView = UIImageView()
        overlayImageView.image = fromImageView.image
        fromImageView.image = nil

        imageViewClipView.frame = originalFrame

        window.addFillingSubview(containerView)
        containerView.addSubview(imageViewClipView)
        containerView.addFillingSubview(button)

        window.layoutIfNeeded()
        window.isUserInteractionEnabled = false

        UIView.animate(
            withDuration: 0.3,
            animations: {
                let newRect = window.bounds.aspectFittingRect(withAspectRatio: imageAspectRatio)
                imageViewClipView.frame = newRect

                containerView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            },
            completion: { _ in
                window.isUserInteractionEnabled = true
            }
        )

        button.setBlock { [unowned containerView] in
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    imageViewClipView.frame = originalFrame

                    containerView.backgroundColor = UIColor(white: 0, alpha: 0)
                },
                completion: { _ in
                    fromImageView.image = image
                    containerView.removeFromSuperview()
                }
            )
        }
    }
}

private extension UIViewController {
    func createView(for image: UIImage, from imageView: UIImageView, withFrame frame: CGRect) -> UIView {
        let imageAspectRatio = image.size.width / image.size.height

        let imageViewClipView = UIView()
        imageViewClipView.clipsToBounds = true
        imageViewClipView.frame = frame

        let overlayImageView = UIImageView()
        overlayImageView.image = image
        overlayImageView.backgroundColor = UIColor.red
        overlayImageView.contentMode = imageView.contentMode
        overlayImageView.translatesAutoresizingMaskIntoConstraints = false

        imageViewClipView.addSubview(overlayImageView)

        overlayImageView.constrainToCenter(of: imageViewClipView)

        overlayImageView.addConstraint(NSLayoutConstraint(
            item: overlayImageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: overlayImageView,
            attribute: .height,
            multiplier: imageAspectRatio,
            constant: 1
        ))

        if frame.aspectRatio < imageAspectRatio {
            imageViewClipView.constrain(.top, of: overlayImageView)
        }
        else {
            imageViewClipView.constrain(.left, of: overlayImageView)
        }

        return imageViewClipView
    }
}
#endif
