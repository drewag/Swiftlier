//
//  MenuItem.swift
//  Speller
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Learn Brigade, LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public struct MenuItem {
    public typealias DismissHandler = (_ completion: (() -> ())?) -> ()

    public enum Action {
        case email(address: String, subject: String)
        case externalURL(address: String)
        case html(content: String)
        case callback((_ dismiss: DismissHandler) -> ())
    }

    let displayText: () -> String
    let icon: UIImage?
    let action: Action
    let isSelected: Bool

    public static func item(named: String, icon: UIImage? = nil, action: Action, isSelected: Bool = false) -> MenuItem {
        return MenuItem(
            displayText: { return named },
            icon: icon,
            action: action,
            isSelected: isSelected
        )
    }
}

public struct MenuSection {
    let name: String?
    let items: [MenuItem]

    public init(name: String?, items: [MenuItem]) {
        self.name = name
        self.items = items
    }
}

public struct Menu {
    let sections: [MenuSection]

    public init(sections: [MenuSection]) {
        self.sections = sections
    }

    public init(items: [MenuItem]) {
        self.sections = [
            MenuSection(name: nil, items: items)
        ]
    }
}
#endif
