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
    public struct Builder {
        let id: String

        var html: String = ""
        var plain: String = ""

        init(id: String) {
            self.id = id
        }

        var headers: [String:String] {
            var headers = [String:String]()
            headers["Mime-Version"] = "1.0"

            if let replyTo = self.replyTo {
                headers["Reply-To"] = Email.sanitize(replyTo)
            }

            if !self.html.isEmpty && !self.plain.isEmpty {
                // Alternate
                headers["Content-Type"] = "multipart/alternative; boundary=\"\(self.id)\""
            }
            else if !self.html.isEmpty {
                // HTML
                headers["Content-Type"] = "text/html; charset=\"UTF-8\""
            }
            else {
                // Plain
                headers["Content-Type"] = "text/plain; charset=\"UTF-8\""
            }

            return headers
        }

        var content: String {
            if !self.html.isEmpty && !self.plain.isEmpty {
                // Alternate
                return """
                    --\(self.id)
                    Content-Type: text/plain; charset="UTF-8"

                    \(self.plain)
                    --\(self.id)
                    Content-Type: text/html; charset="UTF-8"

                    \(self.html)
                    --\(self.id)--
                    """
            }
            else if !self.html.isEmpty {
                // HTML
                return self.html
            }
            else {
                // Plain
                return self.plain
            }
        }

        public var replyTo: String? = nil
        public mutating func append(html: String) {
            self.html += html
        }

        public mutating func append(plain: String) {
            self.plain += plain
        }
    }

    let id: String
    let subject: String
    let recipient: String
    let from: String
    let body: String
    var headers = [String:String]()

    public init(to: String, subject: String, from: String, replyTo: String? = nil, HTMLBody: String) {
        try! self.init(to: to, subject: subject, from: from) { builder in
            builder.replyTo = replyTo
            builder.append(html: HTMLBody)
        }
    }

    public init(to: String, subject: String, from: String, replyTo: String? = nil, plainBody: String) {
        try! self.init(to: to, subject: subject, from: from) { builder in
            builder.replyTo = replyTo
            builder.append(plain: plainBody)
        }
    }

    public init(to: String, subject: String, from: String, build: (inout Builder) throws -> ()) rethrows {
        self.recipient = Email.sanitize(to)
        self.from = Email.sanitize(from)
        self.subject = Email.sanitize(subject)
        let id = UUID().uuidString
        var builder = Builder(id: id)
        try build(&builder)
        self.body = builder.content
        self.headers = builder.headers
        self.id = id
    }

    @discardableResult
    public func send() -> Bool {
        do {
            print("Sending email to '\(self.recipient)' with subject '\(self.subject)'")
            let file = try self.file()

            #if os(Linux)
                let _ = try file.createFile(containing: self.body.data(using: .utf8), canOverwrite: true)
                let task = Process()
                task.launchPath = "/bin/sh"
                var command = "cat \(file.url.relativePath) | mail '\(self.recipient)' -s '\(self.subject)' -a 'From:\(self.from)'"
                for (key,value) in self.headers {
                    command += " -a '\(key):\(value)'"
                }
                task.arguments = ["-c", command]

                task.launch()
                task.waitUntilExit()
                let _ = try? file.delete()
                return task.terminationStatus == 0
            #else
                var body = """
                    Subject: \(self.subject)
                    From: \(self.from)
                    """

                for (key,value) in self.headers {
                    body += "\n\(key): \(value)"
                }
                body += "\n\(self.body)"
                let _ = try file.createFile(containing: body.data(using: .utf8), canOverwrite: true)
                print("Debug mode. See \(file.url.relativePath) for content.")
                return true
            #endif

        }
        catch {
            print("Error sending email: \(error)")
            return false
        }
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

    func file() throws -> Path {
        return try FileSystem.default.rootDirectory.subdirectory("tmp").file("\(self.id).eml")
    }
}
#endif
