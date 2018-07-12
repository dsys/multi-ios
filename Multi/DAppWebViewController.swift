//
//  DAppViewController.swift
//  Multi
//
//  Created by Andrew Gold on 7/4/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit
import WebKit

class DAppWebViewController: UIViewController {
    let dApp: DApp!
    var webView: WKWebView?
    private var iconFetchingUserScript: WKUserScript? = {
        guard let path = Bundle.main.path(forResource: "FetchIcons", ofType: ".js") else {
            return nil
        }
        
        guard let scriptString = try? String.init(contentsOfFile: path) else {
            return nil
        }
        
        let userScript = WKUserScript(source: scriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        return userScript
    }()
    
    required init(dApp: DApp) {
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
        webViewConfiguration.userContentController = userContentController()

        webView = WKWebView(frame: CGRect.zero, configuration: webViewConfiguration)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.uiDelegate = self
        webView?.navigationDelegate = self
        webView?.allowsBackForwardNavigationGestures = true
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
    
    private func userContentController() -> WKUserContentController {
        let userContentController = WKUserContentController()
        
        if dApp.iconURL == nil {
            userContentController.addUserScript(iconFetchingUserScript!)
            userContentController.add(self, name: "didFetchIcons")
        }
        return userContentController
    }
}

extension DAppWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        completionHandler()
    }
}

extension DAppWebViewController: WKNavigationDelegate {
    
}

extension DAppWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let url = message.webView?.url,
        let messageBody = message.body as? [[String:String]] else { return }
        DAppManager.sharedManager!.foundPotentialIconsForDApp(dApp, url: url, potentialIcons: messageBody)
    }
}
