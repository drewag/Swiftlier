//
//  Data+Obfuscation.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 5/3/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

#if os(iOS)
import Foundation

extension Data {
    public init?(secRandomOfCount count: Int) {
        var iv = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, count, &iv)
        guard 0 == status  else {
            return nil
        }
        self.init(iv)
    }
}

public struct ObfuscatedData: ErrorGenerating {
    static let ivLength = 16

    public let keptPlainCount: Int
    public let obfuscated: Data

    public init(clear: Data, keepPlain: Data?, secret: Data) throws {
        guard let iv = Data(secRandomOfCount: ObfuscatedData.ivLength) else {
            throw ObfuscatedData.error("obfuscating data", because: "an iv couldn't be generated")
        }
        self.keptPlainCount = keepPlain?.count ?? 0

        let key = secret.xor(with: iv)
        let length = key.count

        var obfuscated = (keepPlain ?? Data()) + iv
        for (index, byte) in clear.enumerated() {
            obfuscated.append(byte ^ key[index % length])
        }
        self.obfuscated = obfuscated
    }

    public init(obfuscated: Data, keptPlainCount: Int) throws {
        guard obfuscated.count >= keptPlainCount + ObfuscatedData.ivLength else {
            throw ObfuscatedData.error("revealing data", because: "the data is too short")
        }

        self.obfuscated = obfuscated
        self.keptPlainCount = keptPlainCount
    }

    public var keptPlain: Data {
        return self.obfuscated[0..<self.keptPlainCount]
    }

    public func reveal(withSecret secret: Data) -> Data {
        guard !secret.isEmpty else {
            return self.hidden
        }

        let key = secret.xor(with: self.iv)
        return self.hidden.xor(with: key)
    }
}

private extension ObfuscatedData {
    var iv: Data {
        return self.obfuscated[keptPlainCount..<(keptPlainCount + ObfuscatedData.ivLength)]
    }

    var hidden: Data {
        return self.obfuscated[(self.keptPlainCount + ObfuscatedData.ivLength)...]
    }
}

private extension Data {
    func xor(with key: Data) -> Data {
        var output = Data()
        let keyBytes = key.map({$0})
        for (index, byte) in self.enumerated() {
            output.append(byte ^ keyBytes[index % keyBytes.count])
        }
        return output
    }

}
#endif
