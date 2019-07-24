//
//  Data+Base64.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 4/10/17.
//
//

import Foundation

extension Data {
    static let base64Characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")
    static let base64UrlCharacters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")

    public var base64: String {
        return [UInt8](self).base64
    }

    public var base64ForUrl: String {
        return [UInt8](self).base64ForUrl
    }
}

extension Array where Element == UInt8 {
    public var base64: String {
        return self.encode(withCharacters: Data.base64Characters)
    }

    public var base64ForUrl: String {
        return self.encode(withCharacters: Data.base64UrlCharacters)
    }

    private func encode(withCharacters characters: [Character]) -> String {
        var output = ""
        var firstByte: UInt8?
        var secondByte: UInt8?
        var thirdByte: UInt8?

        func appendPattern() {
            guard let first = firstByte else {
                return
            }
            let second = secondByte ?? 0
            let third = thirdByte ?? 0

            output.append(characters[Int(first >> 2)])
            output.append(characters[Int((first << 6) >> 2 + second >> 4)])
            if secondByte == nil {
                output.append("=")
            }
            else {
                output.append(characters[Int((second << 4) >> 2 + third >> 6)])
            }
            if thirdByte == nil {
                output.append("=")
            }
            else {
                output.append(characters[Int(third & 63)])
            }
        }

        for byte in self {
        guard firstByte != nil else {
        firstByte = byte
        continue
        }
        guard secondByte != nil else {
        secondByte = byte
        continue
        }
        thirdByte = byte

        appendPattern()

        firstByte = nil
        secondByte = nil
        thirdByte = nil
        }

        appendPattern()
        return output
    }
}
