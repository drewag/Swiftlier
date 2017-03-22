//
//  NetworkUserReportableResult.swift
//  SwiftPlusPlus
//
//  Created by Eric Dockery on 3/22/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public enum NetworkUserReportableResult<Value> {
    case success(Value)
    case error(NetworkUserReportableError)
}
