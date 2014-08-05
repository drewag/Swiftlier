//
//  Dictionary+Helpers.swift
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

extension Dictionary {
    /**
        :param: f a function to map the key and value into a new value
        
        :returns: a new dictionary with a new value for each key
    */
    func map(f: (Key, Value) -> Value) -> Dictionary<Key, Value> {
        var ret = Dictionary<Key, Value>()
        for (key, value) in self {
            ret[key] = f(key, value)
        }
        return ret
    }

    /**
        Merge two dictionaries together of the same type

        :param: other a dictionary to merge with
        :param: merge a function to merge the values of keys that match betweent the two dictionary

        :returns: a single merged dictionary
    */
    func merge(with other:Dictionary<Key, Value>, by merge: (Value, Value) -> Value) -> Dictionary<Key, Value> {
        var returnDict = self
        for (key, value) in other {
            var returnDictValue = returnDict[key]
            var newValue = returnDictValue != nil ? merge(returnDict[key]!, value) : value
            returnDict.updateValue(newValue, forKey: key)
        }
        return returnDict
    }
}