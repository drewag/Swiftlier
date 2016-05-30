//
//  SelectableValue.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 5/30/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

public struct SelectableValue<Value> {
    public var selected: Bool
    public let value: Value

    public init(value: Value, selected: Bool = true) {
        self.value = value
        self.selected = selected
    }
}