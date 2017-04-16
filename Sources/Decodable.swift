//
//  Decodable.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 12/20/16.
//  Copyright © 2016 Drewag. All rights reserved.
//

public protocol Decodable {
    init(decoder: Decoder) throws
}
