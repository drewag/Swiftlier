//
//  WebViewController.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit
import WebKit

public class WebViewController: UIViewController, ErrorGenerating {
    let activityOverlay = UIActivityIndicatorView(style: .whiteLarge)
    let webView = WKWebView()

    enum Content {
        case url(URL)
        case html(String)
    }
    let content: Content
    let shouldNavigateToUrl: ((URL) -> Bool)?

    public init(URL: URL, shouldNavigateToUrl: ((URL) -> Bool)? = nil) {
        self.content = .url(URL)
        self.shouldNavigateToUrl = shouldNavigateToUrl

        super.init(nibName: nil, bundle: nil)

        self.sharedInit()
    }

    public init(HTML: String, shouldNavigateToUrl: ((URL) -> Bool)? = nil) {
        self.content = .html(HTML)
        self.shouldNavigateToUrl = shouldNavigateToUrl

        super.init(nibName: nil, bundle: nil)

        self.sharedInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.addFillingSubview(self.webView)
        self.view.addCenteredView(self.activityOverlay, withOffset: CGPoint())
    }
}

private extension WebViewController {
    func sharedInit() {
        self.webView.navigationDelegate = self
        self.activityOverlay.color = UIColor.darkGray
        self.activityOverlay.hidesWhenStopped = true

        self.reload()
    }

    func reload() {
        switch self.content {
        case .url(let url):
            let request = URLRequest(url: url)
            self.webView.load(request)
        case .html(let html):
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url
            , let shouldNavigate = self.shouldNavigateToUrl
            , !shouldNavigate(url)
            else
        {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
    }

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityOverlay.startAnimating()
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityOverlay.stopAnimating()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.activityOverlay.stopAnimating()
        self.showAlert(withError: error, "loading", other: [
            .action("OK", handler: {
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            }),
            .action("Try Again", handler: {
                self.reload()
            }),
        ])
    }
}

#endif
