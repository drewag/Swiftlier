//
//  UserReportableResult.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/30/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public enum UserReportableResult<Value> {
    case success(Value)
    case error(UserReportableError)
}
