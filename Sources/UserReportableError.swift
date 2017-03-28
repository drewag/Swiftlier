//
//  UserReportableError.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 4/24/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

public protocol UserReportableError: Error, CustomStringConvertible {
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

extension UserReportableError {
    public var description: String {
        return "\(self.alertTitle): \(self.alertMessage)"
    }
}

public func ==(lhs: UserReportableError, rhs: UserReportableError) -> Bool {
    return lhs.alertTitle == rhs.alertTitle
        && lhs.alertMessage == rhs.alertMessage
}

public func ==(lhs: UserReportableError?, rhs: UserReportableError?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        return lhs.alertTitle == rhs.alertTitle
            && lhs.alertMessage == rhs.alertMessage
    }
    if let _ = lhs {
        return false
    }
    if let _ = rhs {
        return false
    }
    return true
}
