//
//  StreamReader.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/12/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

import Foundation

public class StreamReader  {
    enum Source {
        case file(FileHandle, buffer: Data, chunkSize: Int)
        case data(Data, index: Data.Index)
    }
    private var source: Source

    fileprivate(set) var isAtEndOfFile: Bool = false

    public init(fileHandle: FileHandle, chunkSize: Int = 4096) {
        self.source = .file(fileHandle, buffer: Data(capacity: chunkSize), chunkSize: chunkSize)
    }

    public init(data: Data) {
        self.source = .data(data, index: data.startIndex)
    }

    public convenience init(string: String) {
        self.init(data: string.data(using: .utf8)!)
    }

    deinit {
        switch self.source {
        case let .file(handle, _, _):
            handle.closeFile()
        case .data:
            break
        }
    }

    public func rewind() {
        switch self.source {
        case let .data(data, _):
            self.source = .data(data, index: data.startIndex)
        case let .file(fileHandle, buffer: _, chunkSize: chunkSize):
            fileHandle.seek(toFileOffset: 0)
            self.source = .file(fileHandle, buffer: Data(capacity: chunkSize), chunkSize: chunkSize)
        }
    }

    public func isNextChunk(equalTo other: Data) -> Bool {
        guard !self.isAtEndOfFile else {
            return false
        }

        switch self.source {
        case let .data(data, index: start):
            let end = data.index(start, offsetBy: other.count)
            return data.subdata(in: start ..< end) == other
        case .file(let fileHandle, var buffer, let chunkSize):
            while buffer.count < other.count && !self.isAtEndOfFile {
                self.readNextChunk(ofSize: chunkSize, from: fileHandle, to: &buffer)
            }
            self.source = .file(fileHandle, buffer: buffer, chunkSize: chunkSize)
            let start = buffer.startIndex
            let end = buffer.index(start, offsetBy: other.count)
            return buffer.subdata(in: start ..< end) == other
        }
    }

    public func readUntil(separator: Data) -> Data? {
        if let (found, _) = self.readUntil(anyOf: [separator]) {
            return found
        }
        return nil
    }

    public func readUntil(anyOf separators: [Data]) -> (read: Data, separator: Data?)? {
        guard !self.isAtEndOfFile else {
            return nil
        }

        switch self.source {
        case .file(let fileHandle, var buffer, let chunkSize):
            repeat {
                if let (range, separator) = buffer.range(of: separators, in: buffer.startIndex ..< buffer.endIndex) {
                    let subData = buffer.subdata(in: buffer.startIndex ..< range.lowerBound)
                    buffer.replaceSubrange(buffer.startIndex ..< range.upperBound, with: [])
                    self.source = .file(fileHandle, buffer: buffer, chunkSize: chunkSize)
                    return (subData, separator)
                } else if !self.isAtEndOfFile {
                    self.readNextChunk(ofSize: chunkSize, from: fileHandle, to: &buffer)
                }
                else {
                    return (buffer, nil)
                }
            } while true
        case let .data(data, start):
            if let (range, separator) = data.range(of: separators, in: start ..< data.endIndex) {
                self.source = .data(data, index: range.upperBound)
                return (data.subdata(in: start ..< range.lowerBound), separator)
            }
            self.isAtEndOfFile = true
            if start < data.endIndex {
                return (data.subdata(in: start ..< data.endIndex), nil)
            }
            else {
                return nil
            }
        }
    }
}

private extension Data {
    func range(of separators: [Data], in sourceRange: Range<Data.Index>) -> (Range<Data.Index>, Data)? {
        var found: (Range<Data.Index>, Data)? = nil
        for separator in separators {
            if let range = self.range(of: separator, options: [], in: sourceRange) {
                if let (foundRange, _) = found {
                    if range.lowerBound < foundRange.lowerBound {
                        found = (range, separator)
                    }
                }
                else {
                    found = (range, separator)
                }
            }
        }
        return found
    }
}

private extension StreamReader {
    func readNextChunk(ofSize chunkSize: Int, from fileHandle: FileHandle, to buffer: inout Data) {
        let tempData = fileHandle.readData(ofLength: chunkSize)
        if tempData.count == 0 {
            self.isAtEndOfFile = true
            return
        }
        buffer.append(tempData)
    }
}
