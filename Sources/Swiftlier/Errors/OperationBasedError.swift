//
//  OperationBasedError.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/30/19.
//

public protocol OperationBasedError: SwiftlierError {
    var operation: String {get}
    var reason: String {get}
}

extension OperationBasedError {
    public var title: String {
        return "Error \(operation)"
    }

    public var description: String {
        return "\(self.title): \(self.alertMessage)"
    }

    public var alertMessage: String {
        if self.isInternal {
            return "Internal Error. Please try again. If the problem persists please contact support with the following description: \(self.reason)"
        }
        else {
            return self.reason
        }
    }
}
