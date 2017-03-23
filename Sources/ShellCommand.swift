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

    static let once: Void = {
        signal(SIGINT, { _ in
            for command in commandsToKill {
                command.terminate()
            }
        })
    }()

    #if os(Linux)
        fileprivate let process = Task()
    #else
        fileprivate let process = Process()
    #endif

    fileprivate let parentCommand: ShellCommand?

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

        ShellCommand.once
    }

    deinit {
        self.process.terminate()
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
        self.startExecution()

        commandsToKill.append(self)

        self.process.waitUntilExit()
        self.removeFromCommandsToKill()

        guard self.process.terminationStatus == 0 else {
            throw LocalUserReportableError(source: "ShellCommand", operation: "executing command", message: "Stopping execution", reason: .user)
        }

        if let outputPipe = process.standardOutput as? Pipe {
            let outputString = String(data: outputPipe.fileHandleForReading.availableData, encoding: .utf8) ?? ""
            return outputString
        }
        else {
            return ""
        }
    }

    public func executeAsync() {
        self.startExecution()
    }

    public func terminate() {
        self.process.terminate()
        self.removeFromCommandsToKill()
    }

    public func waitUntilExit() {
        self.process.waitUntilExit()
    }

    public func pipe(to: String, captureOutput: Bool = true) -> ShellCommand {
        return ShellCommand(to, parentCommand: self, captureOutput: captureOutput)
    }

    public var description: String {
        return self.command.joined(separator: " ")
    }
}

private var commandsToKill = [ShellCommand]()

private extension ShellCommand {
    func startExecution() {
        var commands = [ShellCommand]()
        var command: ShellCommand? = self
        repeat {
            commands.append(command!)
            command = command!.parentCommand
        } while command != nil

        for command in commands {
            command.process.launch()
        }
    }

    func removeFromCommandsToKill() {
        if let index = commandsToKill.indexOfValue(passing: {$0 === self}) {
            commandsToKill.remove(at: index)
        }
    }
}
#endif
