//
//  CSVStreamReader.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 2/12/18.
//  Copyright © 2018 Drewag. All rights reserved.
//

import Foundation

public class CSVStreamReader: StreamReader, Sequence, IteratorProtocol {
    fileprivate let encoding: String.Encoding
    fileprivate let delimiter: Data
    fileprivate let quote: Data
    fileprivate var newlineData: Data!

    public init(fileHandle: FileHandle, encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        self.encoding = encoding
        self.delimiter = ",".data(using: encoding)!
        self.quote = "\"".data(using: encoding)!

        super.init(fileHandle: fileHandle, chunkSize: chunkSize)

        self.determineNewLines()
    }

    public init(data: Data, encoding: String.Encoding = .utf8) {
        self.encoding = encoding
        self.delimiter = ",".data(using: encoding)!
        self.quote = "\"".data(using: encoding)!

        super.init(data: data)

        self.determineNewLines()
    }

    public func next() -> [String]? {
        var output = [String]()

        var mode: Mode = .none
        var buffer: Data = Data()
        repeat {
            guard let (read, separator) = self.readUntil(anyOf: [self.newlineData, self.quote, self.delimiter]) else {
                return nil
            }

            guard !self.isAtEndOfFile || separator != nil || !output.isEmpty || !buffer.isEmpty else {
                // Empty last read
                return nil
            }

            func appendBuffer() {
                if let string = String(data: buffer, encoding: self.encoding) {
                    output.append(string)
                }
                buffer = Data()
            }

            switch separator ?? Data() {
            case self.newlineData:
                buffer.append(read)
                switch mode {
                case .quoted:
                    // Ignore as a normal character
                    buffer.append(self.newlineData)
                case .none:
                    appendBuffer()
                    return output
                }
            case self.quote:
                switch mode {
                case .none:
                    buffer.append(read)
                    if read.isEmpty && buffer.isEmpty {
                        mode = .quoted
                    }
                    else {
                        // Ignore as a normal character
                        buffer.append(self.quote)
                    }
                case .quoted:
                    if self.isNextChunk(equalTo: self.quote) {
                        // Escaped quote
                        buffer.append(read)
                        buffer.append(self.quote)
                        let _ = self.readUntil(separator: self.quote)
                    }
                    else if self.isNextChunk(equalTo: self.newlineData) {
                        // End of row
                        buffer.append(read)
                        appendBuffer()
                        mode = .none
                        let _ = self.readUntil(separator: self.newlineData)
                        return output
                    }
                    else if self.isNextChunk(equalTo: self.delimiter) {
                        // End of column
                        buffer.append(read)
                        appendBuffer()
                        mode = .none
                        let _ = self.readUntil(separator: self.delimiter)
                    }
                }
            case self.delimiter:
                switch mode {
                case .none:
                    // End of column
                    buffer.append(read)
                    appendBuffer()
                case .quoted:
                    // Ignore as a normal character
                    buffer.append(read)
                    buffer.append(self.delimiter)
                }
            default:
                // End of file
                buffer.append(read)
                appendBuffer()
                return output
            }
        } while true
    }
}

private extension CSVStreamReader {
    enum Mode {
        case none
        case quoted
    }

    func determineNewLines() {
        defer {
            self.rewind()
        }

        let singleNewline = "\n".data(using: self.encoding)!
        guard let found = self.readUntil(separator: singleNewline) else {
            self.newlineData = singleNewline
            return
        }

        let other = "\r".data(using: self.encoding)!
        guard let range = found.range(of: other) else {
            self.newlineData = singleNewline
            return
        }
        guard range.upperBound == found.endIndex else {
            self.newlineData = singleNewline
            return
        }
        let both = "\r\n".data(using: self.encoding)!
        self.newlineData = both
    }
}
