//
//  WebViewController.swift
//  Swiftlier
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

#if os(iOS)
import UIKit

public class WebViewController: UIViewController, ErrorGenerating {
    let activityOverlay = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    let webView = UIWebView()

    enum Content {
        case url(URL)
        case html(String)
    }
    let content: Content

    public init(URL: URL) {
        self.content = .url(URL)

        super.init(nibName: nil, bundle: nil)

        self.sharedInit()
    }

    public init(HTML: String) {
        self.content = .html(HTML)

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
        self.webView.delegate = self
        self.activityOverlay.color = UIColor.darkGray
        self.activityOverlay.hidesWhenStopped = true

        self.reload()
    }

    func reload() {
        switch self.content {
        case .url(let url):
            let request = URLRequest(url: url)
            self.webView.loadRequest(request)
        case .html(let html):
            self.webView.loadHTMLString(html, baseURL: nil)
        }
    }
}

extension WebViewController: UIWebViewDelegate {
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.activityOverlay.startAnimating()
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityOverlay.stopAnimating()
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
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
