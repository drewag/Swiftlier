//
//  delimeterStreamReader.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/11/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

import Foundation

public class DelimeterStreamReader: StreamReader, Sequence, IteratorProtocol {
    private let encoding: String.Encoding
    private let delimPattern: Data

    public init(fileHandle: FileHandle, delimeter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        self.encoding = encoding
        self.delimPattern = delimeter.data(using: .utf8)!

        super.init(fileHandle: fileHandle, chunkSize: chunkSize)
    }

    public init(data: Data, delimeter: String = "\n", encoding: String.Encoding = .utf8) {
        self.encoding = encoding
        self.delimPattern = delimeter.data(using: .utf8)!

        super.init(data: data)
    }

    public func next() -> String? {
        guard let next = self.readUntil(separator: self.delimPattern) else {
            return nil
        }

        return String(data: next, encoding: self.encoding)
    }
}
