//
//  Data+ReadSafe.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 8/6/17.
//
//

import Foundation

extension FileHandle { 
    public func safelyReadData(ofLength length: Int) -> Data {
        #if os(Linux)
            var leakingData = self.readData(ofLength: length)
            var data: Data = Data() 
            if leakingData.count > 0 { 
                leakingData.withUnsafeMutableBytes({ (bytes: UnsafeMutablePointer<UInt8>) -> Void in
                    data = Data(bytesNoCopy: bytes, count: leakingData.count, deallocator: .free)
                })
            } 
            return data
        #else
            return self.readData(ofLength: length)
        #endif
    }
}
