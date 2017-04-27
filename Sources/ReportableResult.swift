//
//  UserReportableResult.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 5/30/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public enum ReportableResult<Value> {
    case success(Value)
    case error(ReportableError)
}
