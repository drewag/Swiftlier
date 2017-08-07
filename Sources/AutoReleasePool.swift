//
//  AutoReleasePool.swift
//  file-sync-services
//
//  Created by Andrew J Wagner on 8/6/17.
//
//

#if os(Linux)
public func autoreleasepool(_ block: () throws -> ()) rethrows {
    try block()
}
#endif
