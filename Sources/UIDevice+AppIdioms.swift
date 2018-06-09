//
//  UIDevice+AppIdioms.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/22/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

#if os(iOS)
import UIKit

public enum AppIdiom {
    case phone, pad
}

extension UIDevice {
    public var appIdiom: AppIdiom {
        switch self.userInterfaceIdiom {
        case .pad, .tv, .carPlay, .unspecified:
            return .pad
        case .phone:
            return .phone
        }
    }

    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }
}
#endif
