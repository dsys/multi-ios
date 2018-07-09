//
//  DAppViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit
import WebKit

class DAppViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    let dApp: DApp!
    var webView: WKWebView?
    
    init(dApp: DApp) {
        self.dApp = dApp

        super.init(nibName: nil, bundle: nil)
        self.title = dApp.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view
        view?.backgroundColor = UIColor.white

        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        view!.addSubview(webView!)
        
        self.initializeConstraints()
        
        webView?.load(URLRequest(url: URL(string: dApp.url!)!))
    }
    
    private func initializeConstraints() {
        let layoutGuide = self.view.safeAreaLayoutGuide
        
        webView?.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        webView?.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
        webView?.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        webView?.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
    }
    
}
