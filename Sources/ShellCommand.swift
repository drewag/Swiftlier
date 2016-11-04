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
        let process = Process()

        process.launchPath = "/usr/bin/env"
        process.arguments = self.command

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        process.launch()

        let outputString = String(data: outputPipe.fileHandleForReading.availableData, encoding: .utf8) ?? ""
        return outputString
    }

    public var description: String {
        return self.command.joined(separator: " ")
    }
}
