//
//  MenuItem.swift
//  Speller
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Learn Brigade, LLC. All rights reserved.
//

#if os(iOS)
import UIKit

struct MenuItem {
    enum DisplayType {
        case email(address: String, subject: String)
        case externalURL(address: String)
        case html(content: String)
    }

    let displayText: () -> String
    let icon: UIImage?
    let type: DisplayType
}

struct MenuSection {
    let name: String
    let items: [MenuItem]
}

struct Menu {
    let section: [MenuSection]
}
#endif
