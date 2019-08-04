//
//  String+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

import Foundation

extension StringProtocol {
    /// - Parameters:
    ///     - times: the number of times to repeat
    ///     - separator: fixed string to separate repetitions
    ///
    /// - Returns: a string by repeating it 'times' times
    public func repeating(nTimes times: Int, separator: String = "") -> String {
        var result = ""
        for i in 0..<times {
            result += self
            if i < times - 1 {
                result += separator
            }
        }
        return result
    }

    /// Get number of characters that are in common at the end of the other string
    public func numberOfCommonSuffixCharacters<Other: StringProtocol>(with other: Other) -> Int {
        if self.startIndex == self.endIndex || other.startIndex == other.endIndex{
            return 0
        }

        var thisIndex = self.index(before: self.endIndex)
        var otherIndex = other.index(before: other.endIndex)

        var count = 0
        while thisIndex >= self.startIndex && otherIndex >= other.startIndex, self[thisIndex] == other[otherIndex] {
            count += 1

            guard thisIndex > self.startIndex && otherIndex > other.startIndex else {
                break
            }
            thisIndex = self.index(before: thisIndex)
            otherIndex = other.index(before: otherIndex)
        }
        return count
    }

    /// Copy removing all whitespace (newlines, tabs, and spaces) from both ends
    public var trimmingWhitespaceOnEnds: String {
        var output = ""
        var pending = ""
        var foundNonWhitespace = false
        for char in self {
            switch char {
            case "\n", "\t", " ", "\r":
                if foundNonWhitespace {
                    pending.append(char)
                }
                else {
                    continue
                }
            default:
                foundNonWhitespace = true
                if !pending.isEmpty {
                    output += pending
                    pending = ""
                }
                output.append(char)
            }
        }
        return output
    }

    /// Get string index at the given offset
    public func index(at offset: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: offset)
    }

    /// Copy offsetting each character by the given count
    public func offsetCharacters(by count: Int) -> String {
        return String(self.utf8.map({ character in
            let utf8 = character.advanced(by: count)
            let scalar = UnicodeScalar(utf8)
            return Character(scalar)
        }))
    }

    /// Convert to title cased
    ///
    /// Roughly estimates [AP Style](https://www.bkacontent.com/how-to-correctly-use-apa-style-title-case/)
    public var titleCased: String {
        return self.components(separatedBy: " ")
            .enumerated()
            .map({ index, word in
                guard index != 0 else {
                    return word.capitalized(with: Locale.current)
                }

                switch word {
                case "a", "an", "and", "at", "but", "by"
                    , "for", "in", "nor", "of", "on", "or"
                    , "so", "the", "to", "up", "yet":
                    return word
                default:
                    return word.capitalized(with: Locale.current)
                }
            })
            .joined(separator: " ")
    }
}

extension String {
    /// Create a random string of the given length
    ///
    /// The string will be made up only of alphanumerics (upper and lower case)
    public init(randomOfLength length: Int) {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

        var output = ""
        for _ in 0 ..< length {
            let randomNumber = Int.random(in: 0 ..< allowedChars.count)
            let index = allowedChars.index(allowedChars.startIndex, offsetBy: randomNumber)
            let newCharacter = allowedChars[index]
            output.append(newCharacter)
        }
        self = output
    }
}
