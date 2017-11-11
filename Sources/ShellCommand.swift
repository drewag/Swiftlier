//
//  ShellCommand.swift
//  OnBeatCore
//
//  Created by Andrew J Wagner on 11/4/16.
//
//

#if os(Linux) || os(macOS)
import Foundation

public final class ShellCommand: CustomStringConvertible, ErrorGenerating {
    private let command: [String]

    #if os(macOS)
    static let once: Void = {
        signal(SIGINT, { _ in
            for command in commandsToKill {
                command.terminate()
            }
        })
    }()
    #endif

    fileprivate let process = Process()

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

        #if os(macOS)
        ShellCommand.once
        #endif
    }

    deinit {
        #if os(macOS)
        self.process.terminate()
        #endif
    }

    public convenience init(_ command: [String], captureOutput: Bool = true) {
        self.init(command, parentCommand: nil, captureOutput: captureOutput)
    }

    public convenience init(_ command: String, captureOutput: Bool = true) {
        self.init(ShellCommand.commands(from: command), parentCommand: nil, captureOutput: captureOutput)
    }

    private convenience init(_ command: String, parentCommand: ShellCommand?, captureOutput: Bool = true) {
        self.init(ShellCommand.commands(from: command), parentCommand: parentCommand, captureOutput: captureOutput)
    }

    @discardableResult
    public func execute() throws -> String {
        self.startExecution()

        commandsToKill.append(self)

        self.process.waitUntilExit()
        self.removeFromCommandsToKill()

        guard self.process.terminationStatus == 0 else {
            let command = self.command.joined(separator: "")
            throw self.error("executing command", because: "it returned a bad response code \(self.process.terminationStatus). The command was '\(command)'.")
        }

        if let outputPipe = process.standardOutput as? Pipe {
            let outputString = String(data: outputPipe.fileHandleForReading.availableData, encoding: .utf8) ?? ""
            return outputString
        }
        else {
            return ""
        }
    }

    #if os(macOS)
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
    #endif

    public func pipe(to: String, captureOutput: Bool = true) -> ShellCommand {
        return ShellCommand(to, parentCommand: self, captureOutput: captureOutput)
    }

    public var description: String {
        return self.command.joined(separator: " ")
    }
}

private var commandsToKill = [ShellCommand]()

private extension ShellCommand {
    enum CommandMode {
        case singleQuotes
        case doubleQuotes
        case none
    }

    static func commands(from: String) -> [String] {
        var mode = CommandMode.none
        var output = [String]()

        var currentCommand = ""
        for character in from.characters {
            switch (character, mode) {
            case (" ", .none):
                if !currentCommand.isEmpty {
                    output.append(currentCommand)
                    currentCommand = ""
                }
            case ("\"", .none):
                mode = .doubleQuotes
            case ("\"", .doubleQuotes):
                mode = .none
            case ("'", .none):
                mode = .singleQuotes
            case ("'", .singleQuotes):
                mode = .none
            default:
                currentCommand.append(character)
            }
        }

        if !currentCommand.isEmpty {
            output.append(currentCommand)
        }

        return output
    }

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
