//
//  SequenceType+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/1/14.
//  Copyright (c) 2014 Drewag LLC. All rights reserved.
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

private struct ByTwoSequenceIterator<S: Sequence>: IteratorProtocol {
    var sourceIterator: S.Iterator
    var previous: S.Iterator.Element? = nil

    init(source: S) {
        self.sourceIterator = source.makeIterator()
    }

    mutating func next() -> (S.Iterator.Element, S.Iterator.Element)? {
        while let element = self.sourceIterator.next() {
            guard let previous = previous else {
                self.previous = element
                continue
            }
            self.previous = element
            return (previous, element)
        }

        return nil
    }
}

extension Sequence {
    /**
        - parameter test: function to test if an element passes

        - returns: the index of a passing element or nil if none match
    */
    public func indexOfValue(passing test: (_ object: Self.Iterator.Element) -> Bool) -> Int? {
        var index : Int = 0
        for object in self {
            if test(object) {
                return index
            }
            index += 1
        }
        return nil
    }


    /**
        - returns: an array of only elements that can be cast to the resulting type
    */
    public func extractElements<Element>() -> [Element] {
        return self.map({$0 as? Element}).compactMap({$0})
    }

    public func enumerateByTwos() -> AnySequence<(Self.Iterator.Element, Self.Iterator.Element)> {
        return AnySequence({
            return ByTwoSequenceIterator(source: self)
        })
    }
}

extension Sequence where Iterator.Element: Equatable {
    public func unioned<I: Sequence>(with other: I) -> AnySequence<Iterator.Element> where I.Iterator.Element == Iterator.Element {
        var thisGenerator = self.makeIterator()
        let generate: () -> Iterator.Element? = {
            while let next = thisGenerator.next() {
                for otherElement in other {
                    if otherElement == next {
                        return next
                    }
                }
            }

            return nil
        }

        return AnySequence({ AnyIterator(generate) })
    }
}
