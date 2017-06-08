//
//  BinarySearchTree.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 5/31/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public class BinarySearchTree<Element: Comparable>: Sequence, CustomStringConvertible {
    fileprivate enum Parent {
        case none
        case left(BinarySearchTree<Element>)
        case right(BinarySearchTree<Element>)
    }

    fileprivate var element: Element?
    fileprivate var parent: Parent
    fileprivate var left: BinarySearchTree<Element>?
    fileprivate var right: BinarySearchTree<Element>?

    public convenience init() {
        self.init(parent: .none, element: nil)
    }

    public convenience init(values: [Element]) {
        self.init()

        for value in values {
            self.insert(value)
        }
    }

    fileprivate init(parent: Parent, element: Element?) {
        self.parent = parent
        self.element = element
    }

    public var count: Int {
        guard self.element != nil else {
            return 0
        }
        return 1 + (self.left?.count ?? 0) + (self.right?.count ?? 0)
    }

    public var min: Element? {
        return self.sink()?.element
    }

    public var max: Element? {
        guard self.element != nil else {
            return nil
        }

        return self.right?.max ?? self.element
    }

    public func makeIterator() -> BinarySearchTreeIterator<Element> {
        return BinarySearchTreeIterator(node: self.sink())
    }

    public func insert(_ element: Element) {
        guard let existing = self.element else {
            self.element = element
            return
        }
        if element < existing {
            guard let left = self.left else {
                self.left = BinarySearchTree<Element>(parent: .left(self), element: element)
                return
            }
            left.insert(element)
        }
        else {
            guard let right = self.right else {
                self.right = BinarySearchTree<Element>(parent: .right(self), element: element)
                return
            }
            right.insert(element)
        }
    }

    public func elements(between min: Element, and max: Element) -> [Element] {
        var output = [Element]()
        var node = self.firstNode(greatThan: min)
        repeat {
            guard let element = node?.element
                , element < max
                else
            {
                return output
            }
            output.append(element)
            node = node?.next()
        } while node != nil

        return output
    }

    public var description: String {
        return self.description(indentedBy: 0, asLast: true)
    }
}

private extension BinarySearchTree {
    func climb() -> BinarySearchTree<Element>? {
        switch self.parent {
        case .none:
            return nil
        case .left(let parent):
            return parent
        case .right(let parent):
            return parent.climb()
        }
    }

    func sink() -> BinarySearchTree<Element>? {
        guard let left = self.left else {
            return self
        }

        return left.sink()
    }

    func next() -> BinarySearchTree<Element>? {
        guard self.element != nil else {
            // This is only possible on the root node
            return nil
        }

        if let right = self.right {
            return right.sink()
        }
        else {
            return self.climb()
        }
    }

    func description(indentedBy: Int, asLast: Bool) -> String {
        var output = ""
        output.append(" ".repeating(nTimes: indentedBy))
        if asLast {
            output += "└"
        }
        else {
            output += "├"
        }
        output += "── "

        guard let element = self.element else {
            output += "∅"
            return output
        }

        output += "\(element)\n"
        if let left = self.left {
            output += left.description(indentedBy: indentedBy + 4, asLast: false)
        }
        else if self.right != nil {
            output += " ".repeating(nTimes: indentedBy + 4) + "├── ∅\n"
        }
        if let right = self.right {
            output += right.description(indentedBy: indentedBy + 4, asLast: true)
        }
        else if self.left != nil {
            output += " ".repeating(nTimes: indentedBy + 4) + "└── ∅\n"
        }
        return output
    }

    func firstNode(greatThan element: Element) -> BinarySearchTree? {
        guard let existingElement = self.element else {
            // This is only possible on the root node
            return nil
        }

        if element < existingElement {
            return self.left?.firstNode(greatThan: element) ?? self
        }
        else {
            return self.right?.firstNode(greatThan: element)
        }
    }
}

public struct BinarySearchTreeIterator<Element: Comparable>: IteratorProtocol {
    fileprivate var node: BinarySearchTree<Element>?

    public mutating func next() -> Element? {
        guard let element = self.node?.element else {
            // This is only possible on the root node
            return nil
        }

        self.node = self.node?.next()

        return element
    }
}
