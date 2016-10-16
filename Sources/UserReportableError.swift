//
//  UserReportableError.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public protocol UserReportableError: Error {
    var alertTitle: String {get}
    var alertMessage: String {get}
    var otherInfo: [String:String]? {get}
}

extension NSError: UserReportableError {
    public var alertTitle: String {
        return "Error"
    }

    public var alertMessage: String {
        return self.localizedDescription
    }

    public var otherInfo: [String : String]? {
        return nil
    }
}
