//
//  String+Helpers.swift
//  lists
//
//  Created by Andrew Wagner on 6/4/14.
//  Copyright (c) 2014 Learn Brigade, LLC. All rights reserved.
//

extension String {
    func repeat(times: Int) -> String {
        var result = ""
        for i in 0..times {
            result += self
        }
        return result
    }
}