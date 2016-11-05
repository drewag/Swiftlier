//
//  ShellCommand.swift
//  OnBeatCore
//
//  Created by Andrew J Wagner on 11/4/16.
//
//

import Foundation

public struct ShellCommand: CustomStringConvertible {
    private let command: [String]

    public init(_ command: [String]) {
        self.command = command
    }

    public func execute() -> String {
        #if os(Linux)
            let BUFSIZE = 1024
            let fullCommand = "/bin/sh -c \'\(command)\'"
            let pp = popen(fullCommand, "r")
            var buf = [CChar](repeating: CChar(0), count:BUFSIZE)

            var output = ""
            while fgets(&buf, Int32(BUFSIZE), pp) != nil {
                output += String(cString: buf)
            }
            guard !output.isEmpty else {
                return output
            }
            if output.characters.last == "\n" {
                return output.substring(to: output.characters.count - 2)
            } else {
                return output
            }
        #else
            let process = Process()

            process.launchPath = "/usr/bin/env"
            process.arguments = self.command

            let outputPipe = Pipe()
            process.standardOutput = outputPipe

            process.launch()

            let outputString = String(data: outputPipe.fileHandleForReading.availableData, encoding: .utf8) ?? ""
            return outputString
        #endif
    }

    public var description: String {
        return self.command.joined(separator: " ")
    }
}
