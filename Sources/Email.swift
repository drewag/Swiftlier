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
    let contentType: ContentType

    public init(to: String, subject: String, from: String, HTMLBody: String) {
        self.recipient = Email.sanitize(to)
        self.body = HTMLBody
        self.contentType = .html
        self.subject = Email.sanitize(subject)
        self.from = Email.sanitize(from)
    }

    public init(to: String, subject: String, from: String, plainBody: String) {
        self.recipient = Email.sanitize(to)
        self.body = plainBody
        self.contentType = .plain
        self.subject = Email.sanitize(subject)
        self.from = Email.sanitize(from)
    }

    @discardableResult
    public func send() -> Bool {
        #if os(Linux)
            print("Sending email to '\(self.recipient)' with subject '\(self.subject)'")

            do {
                FileService.default.createDirectory(at: URL(fileURLWithPath: "tmp"))
                let tempPath = "tmp/email.html"
                try self.HTMLBody.write(toFile: tempPath, atomically: true, encoding: .utf8)
                let task = Task()
                task.launchPath = "/bin/sh"
                var command = "cat \(tempPath) | mail '\(self.recipient)' -s '\(self.subject)' -a 'From:\(self.from)'"
                switch self.contentType {
                case .html:
                    command += " -a 'Content-Type: text/html'"
                case .plain:
                    break
                }
                task.arguments = ["-c", command]

                task.launch()
                task.waitUntilExit()
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
}
#endif
