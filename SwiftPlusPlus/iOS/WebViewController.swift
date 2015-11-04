//
//  WebViewController.swift
//  SwiftPlusPlus
//
//  Created by Andrew J Wagner on 11/4/15.
//  Copyright © 2015 Drewag LLC. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    let webView = UIWebView()

    convenience init(URL: NSURL) {
        self.init()

        let request = NSURLRequest(URL: URL)
        self.webView.loadRequest(request)
    }

    convenience init(HTML: String) {
        self.init()

        self.webView.loadHTMLString(HTML, baseURL: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addFillingSubview(self.webView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.webView.scrollView.scrollEnabled = self.webView.scrollView.contentSize.height > self.webView.bounds.height
    }
}