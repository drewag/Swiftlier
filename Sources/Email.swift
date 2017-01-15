//
//  Email.swift
//  drewag.me
//
//  Created by Andrew J Wagner on 1/14/17.
//
//

#if os(macOS) || os(Linux)
public struct Email {
    let subject: String
    let HTMLBody: String
    let recipient: String
    let from: String

    public init(to: String, subject: String, from: String, HTMLBody: String) {
        self.recipient = to
        self.HTMLBody = HTMLBody.replacingOccurrences(of: "'", with: "\\\\'")
        self.subject = subject
        self.from = from
    }

    @discardableResult
    public func send() -> Bool {
        #if os(Linux)
            print("Sending email to '\(self.recipient)' with subject '\(self.subject)'")
            let task = Task()
            task.launchPath = "/bin/sh"
            task.arguments = ["-c", "echo '\(self.HTMLBody)' | mail '\(self.recipient)' -s '\(self.subject)' -a 'From:\(self.from)' -a 'Content-Type: text/html'"]

            task.launch()
            task.waitUntilExit()
            return task.terminationStatus == 0
        #else
            print("Sent email to '\(self.recipient)' with subject '\(self.subject)' and body '\(self.HTMLBody)'")
            return true
        #endif
    }
}
#endif
