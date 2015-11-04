//
//  MenuItem.swift
//  Speller
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Learn Brigade, LLC. All rights reserved.
//

import UIKit

struct MenuItem {
    enum Type {
        case Email(address: String, subject: String)
        case ExternalURL(address: String)
        case HTML(content: String)
    }

    let displayText: () -> String
    let icon: UIImage?
    let type: Type
}

struct MenuSection {
    let name: String
    let items: [MenuItem]
}

struct Menu {
    let section: [MenuSection]
}