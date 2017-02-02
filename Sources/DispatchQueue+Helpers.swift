//
//  DispatchQueue+Helpers.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 2/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

extension DispatchQueue {
    public func asyncAfter(seconds: Double, execute work: @escaping @convention(block) () -> ()) {
        let time = DispatchTime.now() + seconds
        self.asyncAfter(deadline: time, execute: work)
    }
}
