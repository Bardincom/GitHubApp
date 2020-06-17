//
//  WKWebViewController.swift
//  GitHubApp
//
//  Created by Polina on 13.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation
import UIKit
import WebKit

final class WKWebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var repositoryURL: String!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let repoURL = URL(string: repositoryURL) else { return }
        let request = URLRequest(url: repoURL)
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        
        let source = "document.body.style.background = \"#77B3FF\";"
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view = webView
    }
}

