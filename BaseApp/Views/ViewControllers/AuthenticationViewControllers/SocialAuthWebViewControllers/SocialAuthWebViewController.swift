//
//  SocialAuthWebViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/22/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import WebKit

/// A `BaseViewController` responsible for displaying a webview. The webview displays content related to OAuth
/// authentication.
final class SocialAuthWebViewController: BaseViewController {
    
    // MARK: - Private Instance Methods
    @objc private var webView: WKWebView!
    private var redirectUri: URL!
    private var oauthUrl: URL!
    private var observation: NSKeyValueObservation?
    
    
    // MARK: - Public Instance Attributes
    var redirectUrlWithQueryParametersRecieved: ((_ redirectUrlWithQueryParameters: URL) -> Void)?
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SocialAuthWebViewController`.
    ///
    /// - Parameters:
    ///   - redirectUri: A `String` representing the redirect uri used for a OAuth provider.
    ///   - oauthUrl: A `URL` representing the url for performing OAuth authentication.
    init(redirectUri: String, oauthUrl: URL) {
        super.init(nibName: nil, bundle: nil)
        self.redirectUri = URL(string: redirectUri)!
        self.oauthUrl = oauthUrl
        setup()
    }
    
    /// Required initializer for Subclass.
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Deinitializers
    
    /// Deinitializes an instance of `SocialAuthWebViewController`.
    deinit {
        observation = nil
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.load(URLRequest(url: oauthUrl))
    }
}


// MARK: - WKNavigationDelegate
extension SocialAuthWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let authorizationUrl = navigationAction.request.url,
              authorizationUrl.host == redirectUri.host else {
                decisionHandler(.allow)
                return
        }
        if let closure = redirectUrlWithQueryParametersRecieved {
            closure(authorizationUrl)
            dismissView()
        }
        decisionHandler(.cancel)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        finishProgressBar()
    }
}


// MARK: - Private Instance Methods
private extension SocialAuthWebViewController {
    
    /// Sets up the default logic for the view.
    func setup() {
        if !isViewLoaded { return }
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = false
        let keypath = \WKWebView.estimatedProgress
        observation = webView.observe(keypath) { [weak self] (_, _) in
            guard let strongSelf = self else { return }
            let progress = Float(strongSelf.webView.estimatedProgress)
            strongSelf.setProgressForNavigationBar(progress: progress)
        }
        let buttonTitle = NSLocalizedString("Miscellaneous.Cancel", comment: "Back Button")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: buttonTitle,
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
        view = webView
    }
    
    /// Dismiss the view.
    @objc func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
