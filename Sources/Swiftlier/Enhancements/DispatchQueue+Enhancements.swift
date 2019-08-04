//
//  DispatchQueue+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

extension DispatchQueue {
    /// Execute the work after a certain number of seconds
    ///
    /// - Parameters:
    ///     - seconds: Number of seconds to wait to perform the work
    ///     - work: Work to execute after delay
    public func asyncAfter(seconds: TimeInterval, execute work: @escaping @convention(block) () -> ()) {
        let time = DispatchTime.now() + seconds
        self.asyncAfter(deadline: time, execute: work)
    }
}
