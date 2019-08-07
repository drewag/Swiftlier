//
//  URLSession+Testing.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 7/16/19.
//  Copyright © 2019 Drewag. All rights reserved.
//

import Foundation

public protocol AnyURLSession {
    func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask
    func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

public class TestURLSession: AnyURLSession {
    public enum Kind {
        case fileUpload(URL, (Data?, URLResponse?, Error?) -> Void)
        case download
        case data
    }

    public struct StartedTask {
        let url: URL?
        let kind: Kind
    }

    public var startedTasks = [StartedTask]()

    public func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
        return TestURLSessionUploadTask(session: self, request: request, file: fileURL, completionHandler: completionHandler)
    }

    public func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
        return TestURLSessionDownloadTask(session: self, url: url, completionHandler: completionHandler)
    }

    public func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return TestURLSessionDataTask(session: self, request: request, completionHandler: completionHandler)
    }

    public init() {}
}

extension URLSession: AnyURLSession {}

private class TestURLSessionUploadTask: URLSessionUploadTask {
    let session: TestURLSession
    let task: TestURLSession.StartedTask

    init(session: TestURLSession, request: URLRequest, file: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.session = session
        self.task = .init(url: request.url, kind: .fileUpload(file, completionHandler))
    }

    override func resume() {
        self.session.startedTasks.append(self.task)
    }
}

private class TestURLSessionDownloadTask: URLSessionDownloadTask {
    let session: TestURLSession
    let task: TestURLSession.StartedTask

    init(session: TestURLSession, url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) {
        self.session = session
        self.task = .init(url: url, kind: .download)
    }

    override func resume() {
        self.session.startedTasks.append(self.task)
    }
}

private class TestURLSessionDataTask: URLSessionDataTask {
    let session: TestURLSession
    let task: TestURLSession.StartedTask

    init(session: TestURLSession, request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.session = session
        self.task = .init(url: request.url, kind: .data)
    }

    override func resume() {
        self.session.startedTasks.append(self.task)
    }
}
