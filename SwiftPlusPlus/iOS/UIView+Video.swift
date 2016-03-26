//
//  UIView+Video.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 9/11/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit
import MediaPlayer
import ObjectiveC

extension UIView {
    struct Keys {
        static var VideoController = "VideoController"
    }

    func playVideoWithURL(URL: NSURL) -> VideoController {
        let videoController = VideoController(URL: URL, inView: self)
        objc_setAssociatedObject(
            self,
            &Keys.VideoController,
            videoController,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return videoController
    }
}

public class VideoController: NSObject {
    let moviePlayer: MPMoviePlayerController
    unowned let view: UIView

    private init(URL: NSURL, inView: UIView) {
        self.view = inView
        self.moviePlayer = MPMoviePlayerController(contentURL: URL)

        super.init()

        self.moviePlayer.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
    }

    func resume() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(moviePlayerPreparedToPlayDidChange(_:)),
            name: MPMediaPlaybackIsPreparedToPlayDidChangeNotification,
            object: self.moviePlayer
        )
        if self.moviePlayer.isPreparedToPlay {
            self.moviePlayer.play()
        }
        else {
            self.moviePlayer.prepareToPlay()
        }
    }

    func pause() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: MPMediaPlaybackIsPreparedToPlayDidChangeNotification,
            object: self.moviePlayer
        )
        self.moviePlayer.pause()
    }

    func stop() {
        self.pause()
        self.moviePlayer.stop()
        self.moviePlayer.view.removeFromSuperview()
    }

    deinit {
        self.stop()
    }

    // MARK: Notifications

    func moviePlayerPreparedToPlayDidChange(notification: NSNotification) {
        if self.moviePlayer.isPreparedToPlay {
            if self.moviePlayer.view.superview == nil {
                self.moviePlayer.view.frame = self.view.bounds
                self.view.addSubview(self.moviePlayer.view)
            }
        }
    }
}
