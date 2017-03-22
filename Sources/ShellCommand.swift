//
//  ShellCommand.swift
//  OnBeatCore
//
//  Created by Andrew J Wagner on 11/4/16.
//
//

#if os(Linux) || os(macOS)
import Foundation

public final class ShellCommand: CustomStringConvertible {
    private let command: [String]

    #if os(Linux)
        private let process = Task()
    #else
        private let process = Process()
    #endif

    private let parentCommand: ShellCommand?

    private init(_ command: [String], parentCommand: ShellCommand?, captureOutput: Bool) {
        self.command = command
        self.parentCommand = parentCommand

        self.process.arguments = self.command
        self.process.launchPath = "/usr/bin/env"
        self.process.standardInput = Pipe()
        if let parentCommand = parentCommand {
            parentCommand.process.standardOutput = self.process.standardInput
        }
        else if captureOutput {
            self.process.standardOutput = Pipe()
        }
    }

    public convenience init(_ command: [String], captureOutput: Bool = true) {
        self.init(command, parentCommand: nil, captureOutput: captureOutput)
    }

    public convenience init(_ command: String, captureOutput: Bool = true) {
        self.init(command.components(separatedBy: " "), parentCommand: nil, captureOutput: captureOutput)
    }

    private convenience init(_ command: String, parentCommand: ShellCommand?, captureOutput: Bool = true) {
        self.init(command.components(separatedBy: " "), parentCommand: parentCommand, captureOutput: captureOutput)
    }

    @discardableResult
    public func execute() throws -> String {
        var commands = [ShellCommand]()
        var command: ShellCommand? = self
        repeat {
            commands.append(command!)
            command = command!.parentCommand
        } while command != nil

        for command in commands {
            command.process.launch()
        }

        self.process.waitUntilExit()

        guard self.process.terminationStatus == 0 else {
            if let errorPipe = self.process.standardError as? Pipe {
                let outputString = String(data: errorPipe.fileHandleForReading.availableData, encoding: .utf8) ?? ""
                throw LocalUserReportableError(source: "ShellCommand", operation: "executing command", message: outputString, reason: .user)
            }
            else {
                throw LocalUserReportableError(source: "ShellCommand", operation: "executing command", message: "", reason: .user)
            }
        }

        if let outputPipe = process.standardOutput as? Pipe {
            let outputString = String(data: outputPipe.fileHandleForReading.availableData, encoding: .utf8) ?? ""
            return outputString
        }
        else {
            return ""
        }
    }

    public func pipe(to: String) -> ShellCommand {
        return ShellCommand(to, parentCommand: self)
    }

    public var description: String {
        return self.command.joined(separator: " ")
    }
}
#endif
