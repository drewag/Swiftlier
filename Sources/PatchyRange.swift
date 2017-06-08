//
//  PatchyRange.swift
//  SwiftlieriOS
//
//  Created by Andrew J Wagner on 6/2/17.
//  Copyright © 2017 Drewag. All rights reserved.
//

public struct PatchyRange<Value: Comparable> {
    fileprivate struct Node {
        let value: Value
        var opening: Int = 0
        var closing: Int = 0
        var openAndClose: Int = 0

        init(openingWith value: Value) {
            self.value = value
            self.opening = 1
        }

        init(closingWith value: Value) {
            self.value = value
            self.closing = 1
        }

        init(openingAndClosingWith value: Value) {
            self.value = value
            self.openAndClose = 1
        }

        var includeTheFollwing: Bool {
            return (opening - closing) > 0
        }
    }

    fileprivate var nodes = [Node]()

    public init() {}

    public mutating func appendRange(from: Value, to: Value) {
        defer {
            print("Before clean: \(self)")
            self.cleanupNodes()
            print("After clean: \(self)")
        }

        guard from < to else {
            if from == to, let index = self.indexOfNode(onOrBefore: from) {
                if self.nodes[index].value == from {
                    self.nodes[index].openAndClose += 1
                }
                else {
                    self.nodes.insert(Node(openingAndClosingWith: from), at: index + 1)
                }
            }
            return
        }

        if let index = self.indexOfNode(onOrBefore: from) {
            if self.nodes[index].value == from {
                self.nodes[index].opening += 1
            }
            else {
                self.nodes.insert(Node(openingWith: from), at: index + 1)
            }
        }
        else {
            self.nodes.insert(Node(openingWith: from), at: 0)
        }


        if let index = self.indexOfNode(onOrAfter: to) {
            if self.nodes[index].value == to {
                self.nodes[index].closing += 1
            }
            else {
                self.nodes.insert(Node(closingWith: to), at: index)
            }
        }
        else {
            self.nodes.append(Node(closingWith: to))
        }
    }

    public func contains(_ value: Value) -> Bool {
        guard let index = self.indexOfNode(onOrBefore: value) else {
            return false
        }

        return self.nodes[index].value == value
            || self.nodes[index].includeTheFollwing
    }
}

extension PatchyRange: CustomStringConvertible {
    public var description: String {
        var output = "PatchRange("
        for (index, node) in self.nodes.enumerated() {
            if index > 0 {
                output += " "
            }
            output += "\(node.value)"
            if node.opening != 0 {
                output += "+\(node.opening)"
            }
            if node.openAndClose != 0 {
                output += "#\(node.openAndClose)"
            }
            if node.closing != 0 {
                output += "-\(node.closing)"
            }
        }
        return output + ")"
    }
}

private extension PatchyRange {
    func indexOfFirstValue(greaterThanOrEqualTo value: Value) -> Int? {
        for (index, node) in self.nodes.enumerated() {
            if node.value >= value {
                return index
            }
        }
        return nil
    }

    func indexOfNode(onOrBefore before: Value) -> Int? {
        guard let index = indexOfFirstValue(greaterThanOrEqualTo: before) else {
            return self.nodes.count > 0 ? self.nodes.count - 1 : nil
        }

        guard self.nodes[index].value != before else {
            return index
        }

        guard index > 0 else {
            return nil
        }

        return index - 1
    }

    func indexOfNode(onOrAfter after: Value) -> Int? {
        guard let index = indexOfFirstValue(greaterThanOrEqualTo: after), index < self.nodes.count else {
            return nil
        }

        guard self.nodes[index].value != after else {
            return index
        }

        return index
    }

    mutating func cleanupNodes() {
        var includeCount = 0
        for (index, node) in self.nodes.enumerated().reversed() {
            includeCount -= node.opening
            includeCount += node.closing

            print(node)
            print(includeCount)

            if node.opening > 0 {
                if includeCount > 0 {
                    self.nodes.remove(at: index)
                }
                else {
                    self.nodes[index] = Node(openingWith: node.value)
                }
                continue
            }
            else if node.closing > 0 {
                if includeCount - node.closing > 0 {
                    self.nodes.remove(at: index)
                }
                else {
                    self.nodes[index] = Node(closingWith: node.value)
                }
                continue
            }
            else if node.openAndClose > 0 {
                if includeCount > 0 {
                    self.nodes.remove(at: index)
                }
                continue
            }
        }
    }
}
