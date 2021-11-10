// 
//  OpenBankingAccountWebViewCoordinator.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

final class OpenBankingAccountWebViewCoordinator: NSObject {
    
    // MARK: - Value
    // MARK: Public
    let view: OpenBankingAccountWebView
    
    // MARK: Private
    private var subscriber: AnyCancellable? = nil
    
    
    // MARK: - Initializer
    init(webView: OpenBankingAccountWebView) {
        view = webView
        super.init()
        
        setPublisher()
    }
    
    deinit {
        subscriber?.cancel()
    }

    
    // MARK: - Function
    // MARK: Private
    private func setPublisher() {
        subscriber = view.data.webViewRequestPublisher
            .sink { [weak self] in
                guard let webView = self?.view.webView else { return }
                $0.1.forEach { webView.configuration.websiteDataStore.httpCookieStore.setCookie($0) }
                webView.load($0.0)
            }
    }
}


// MARK: - WKNavigation Delegate
extension OpenBankingAccountWebViewCoordinator: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        log(.info, navigationAction.request.debugDescription)
        
        preferences.preferredContentMode = .mobile
        decisionHandler(.allow, preferences)
        
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies {
            log(.info, $0)
        }
        
        guard let url = webView.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let serviceURL = ServiceURL(components: components) else { return }
        
        switch serviceURL {
        case .openBankingCallBack:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && OpenBankingServer(server: server).rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    do {
                        let response = try OpenBankingCallConfirmationResponse(url: webView.url, cookie: cookie)
                        self.view.data.webViewResponsePublisher.send(response)
                    
                    } catch {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                    }
                }
            }
            
        default:
            break
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let serviceURL = ServiceURL(components: components) else {
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
            }
           
            return
        }
        
        switch serviceURL {
        case .openBankingARS:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && OpenBankingServer(server: server).rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    if let response = try? OpenBankingARSResponse(value: value, cookie: cookie) {
                        self.view.data.webViewResponsePublisher.send(response)
                        return
                    }
                    
                    if let response = try? OpenBankingCallResponse(value: value, cookie: cookie) {
                        self.view.data.webViewResponsePublisher.send(response)
                        return
                    }
                    
                    self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                }
            }
            
        case .openBankingCallBack:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && OpenBankingServer(server: server).rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    do {
                        let response = try OpenBankingCallConfirmationResponse(url: webView.url, cookie: cookie)
                        self.view.data.webViewResponsePublisher.send(response)
                    
                    } catch {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                    }
                }
            }
            
        default:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        log(.error, error.localizedDescription)
        self.view.data.webViewResponsePublisher.send(completion: .failure(error))
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        log(.error, error.localizedDescription)
        self.view.data.webViewResponsePublisher.send(completion: .failure(error))
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        log(.info, webView.url)
    }
}
