//
//  ValidEmail.swift
//  SwiftPlusPlus
//
//  Created by Eric Dockery on 4/7/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

struct ValidEmail {
    public init(string: String) throws {
        guard string.isValidEmail else {
            throw LocalUserReportableError(
                source: "Email Validation",
                operation: "checking email structure",
                message: "Email isn't in valid format",
                reason: .user
            )
        }
    }
}
