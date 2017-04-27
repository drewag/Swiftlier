//
//  Email.swift
//  drewag.me
//
//  Created by Andrew J Wagner on 1/14/17.
//
//

#if os(macOS) || os(Linux)
import Foundation

public struct Email {
    enum ContentType {
        case html
        case plain
    }

    let subject: String
    let body: String
    let recipient: String
    let from: String
    let replyTo: String?
    let contentType: ContentType

    public init(to: String, subject: String, from: String, replyTo: String? = nil, HTMLBody: String) {
        self.recipient = Email.sanitize(to)
        self.body = HTMLBody
        self.contentType = .html
        self.subject = Email.sanitize(subject)
        self.from = Email.sanitize(from)
        self.replyTo = Email.sanitize(replyTo)
    }

    public init(to: String, subject: String, from: String, replyTo: String? = nil, plainBody: String) {
        self.recipient = Email.sanitize(to)
        self.body = plainBody
        self.contentType = .plain
        self.subject = Email.sanitize(subject)
        self.from = Email.sanitize(from)
        self.replyTo = Email.sanitize(replyTo)
    }

    @discardableResult
    public func send() -> Bool {
        #if os(Linux)
            print("Sending email to '\(self.recipient)' with subject '\(self.subject)'")

            do {
                let file = try FileSystem.default.workingDirectory.subdirectory("tmp")
                    .addFile(named: "email.html", containing: self.body.data(using: .utf8), canOverwrite: true)
                let task = Process()
                task.launchPath = "/bin/sh"
                var command = "cat \(file.url.relativePath) | mail '\(self.recipient)' -s '\(self.subject)' -a 'From:\(self.from)'"
                if let replyTo = self.replyTo {
                    command += " -a 'Reply-To:\(replyTo)'"
                }
                switch self.contentType {
                case .html:
                    command += " -a 'Content-Type: text/html'"
                case .plain:
                    break
                }
                task.arguments = ["-c", command]

                task.launch()
                task.waitUntilExit()
                let _ = try? file.delete()
                return task.terminationStatus == 0
            }
            catch {
                print("Error sending email: \(error)")
                return false
            }
        #else
            print("Sent email to '\(self.recipient)' with subject '\(self.subject)' and body '\(self.body)'")
            return true
        #endif
    }
}

private extension Email {
    static func sanitize(_ parameter: String) -> String {
        return parameter.replacingOccurrences(of: "'", with: "\\'")
    }

    static func sanitize(_ parameter: String?) -> String? {
        guard let param = parameter else {
            return nil
        }
        return self.sanitize(param)
    }
}
#endif
