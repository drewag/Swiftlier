//
//  Array+Sorting.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 4/1/16.
//  Copyright © 2016 Drewag LLC. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    /// Insert an element assuming it is already sorted
    ///
    /// - Parameters:
    ///     - new: element to insert
    ///     - assumingAlreadySortedBy: sorting algorithm
    ///
    /// - Returns: the index the element has been inserted at
    @discardableResult
    public mutating func insert(_ new: Element, assumingAlreadySortedBy isOrderedBefore: (Element, Element) -> (Bool)) -> Self.Index {
        for index in self.indices {
            if !isOrderedBefore(self[index], new) {
                self.insert(new, at: index)
                return index
            }
        }
        let index = self.endIndex
        self.append(new)
        return index
    }
}

extension Sequence {
    /// Enumerate getting 2 elemnts at a time
    ///
    /// For example "[0,1,2,3]" will enumerate the pairs:
    /// - (0, 1)
    /// - (1, 2)
    /// - (2, 3)
    public func enumerateByTwos() -> AnySequence<(Self.Iterator.Element, Self.Iterator.Element)> {
        return AnySequence({
            return ByTwoSequenceIterator(source: self)
        })
    }
}

extension Sequence where Iterator.Element: Equatable {
    /// Create a sequence of elements that are also in *other* sequence
    ///
    /// - Parameter other: sequence to look for equal elements
    ///
    /// - Returns: sequence of elements in both sequences that are equal
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
