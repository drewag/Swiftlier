//
//  UIDevice+AppIdioms.swift
//  SwiftPlusPlus
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
}
#endif
