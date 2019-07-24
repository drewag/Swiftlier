//
//  SequenceType+Helpers.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 8/1/14.

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
