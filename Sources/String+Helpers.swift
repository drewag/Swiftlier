//
//  String+Helpers.swift
//  lists
//
//  Copyright (c) 2014 Drewag, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

extension StringProtocol {
    /**
        - parameter times: the number of times to repeat the string

        - returns: a string by repeating it 'times' times
    */
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

    public var trimmingWhitespaceOnEnds: String {
        var output = ""
        var pending = ""
        var foundNonWhitespace = false
        for char in self {
            switch char {
            case "\n", "\t", " ":
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
}

extension String {
    public func index(at: Int) -> String.Index {
        return self.index(self.startIndex, offsetBy: at)
    }

    public func offsetCharacters(by count: Int) -> String {
        return String(self.utf8.map({ character in
            let utf8 = character.advanced(by: count)
            let scalar = UnicodeScalar(utf8)
            return Character(scalar)
        }))
    }
}
