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
    let subject: String
    let HTMLBody: String
    let recipient: String
    let from: String

    public init(to: String, subject: String, from: String, HTMLBody: String) {
        self.recipient = to
        self.HTMLBody = HTMLBody
        self.subject = subject
        self.from = from
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
                task.arguments = ["-c", "cat \(tempPath) | mail '\(self.recipient)' -s '\(self.subject)' -a 'From:\(self.from)' -a 'Content-Type: text/html'"]

                task.launch()
                task.waitUntilExit()
                return task.terminationStatus == 0
            }
            catch {
                return false
            }
        #else
            print("Sent email to '\(self.recipient)' with subject '\(self.subject)' and body '\(self.HTMLBody)'")
            return true
        #endif
    }
}
#endif
