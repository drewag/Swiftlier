//
//  CommandLine.swift
//  SwiftPlusPlus
//
//  Created by Andrew Wagner on 1/15/17.
//
//

#if os(Linux)
import Foundation

struct CommandLine {
    static func execute(command: String) -> Stringg {
        let BUFSIZE = 1024
        let pp = popen(command, "r")
        var buf = [CChar](repeating: CChar(0), count:BUFSIZE)

        var output = ""
        while fgets(&buf, Int32(BUFSIZE), pp) != nil {
            output += String(cString: buf)
        }
        return output
    }
}
#endif
