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

extension String {
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

    public func substring(from index: Int) -> String {
        var pos = self.startIndex
        pos = self.index(pos, offsetBy: index)
        return self.substring(from: pos)
    }

    public func substring(to index: Int) -> String {
        var pos = self.startIndex
        pos = self.index(pos, offsetBy: index)
        return self.substring(to: pos)
    }

    public var isValidEmail: Bool {
        #if os(Linux)
            return true
        #else
            let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"

            let emailTest = NSPredicate(format:"SELF MATCHES %@", argumentArray: [emailRegEx])
            return emailTest.evaluate(with: self)
        #endif
    }
}

#if os(iOS)
public func /(lhs: String, rhs: String) -> String {
    return lhs.appendingPathComponent(rhs)
}
#endif
