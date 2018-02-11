//
//  delimeterStreamReader.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/11/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

import Foundation

public class DelimeterStreamReader: Sequence, IteratorProtocol {
    fileprivate let fileHandle: FileHandle

    private let chunkSize: Int
    private let encoding: String.Encoding

    private var buffer: Data
    private let delimPattern: Data
    private var isAtEndOfFile: Bool = false

    init(fileHandle: FileHandle, delimeter: String = "\n", encoding: String.Encoding, chunkSize: Int = 4096) {
        self.fileHandle = fileHandle
        self.encoding = encoding
        self.chunkSize = chunkSize

        self.buffer = Data(capacity: chunkSize)
        self.delimPattern = delimeter.data(using: .utf8)!
    }

    deinit {
        self.fileHandle.closeFile()
    }

    public func next() -> String? {
        guard !self.isAtEndOfFile else {
            return nil
        }

        repeat {
            if let range = self.buffer.range(of: self.delimPattern, options: [], in: self.buffer.startIndex ..< self.buffer.endIndex) {
                let subData = self.buffer.subdata(in: self.buffer.startIndex ..< range.lowerBound)
                let next = String(data: subData, encoding: self.encoding)
                self.buffer.replaceSubrange(self.buffer.startIndex ..< range.upperBound, with: [])
                return next
            } else {
                let tempData = self.fileHandle.readData(ofLength: self.chunkSize)
                if tempData.count == 0 {
                    self.isAtEndOfFile = true
                    return (self.buffer.count > 0) ? String(data: self.buffer, encoding: self.encoding) : nil
                }
                self.buffer.append(tempData)
            }
        } while true
    }
}
