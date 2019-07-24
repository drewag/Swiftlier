//
//  String+Random.swift
//  ssm
//
//  Created by Andrew J Wagner on 3/18/17.
//
//

import Foundation

extension String {
    public init(randomOfLength length: Int) {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)

        var output = ""
        for _ in 0 ..< length {
            #if os(Linux)
                let randomNumber = Int(random()) % Int(allowedCharsCount)
            #else
                let randomNumber = Int(arc4random_uniform(allowedCharsCount))
            #endif
            let index = allowedChars.index(allowedChars.startIndex, offsetBy: randomNumber)
            let newCharacter = allowedChars[index]
            output.append(newCharacter)
        }
        self = output
    }
}
