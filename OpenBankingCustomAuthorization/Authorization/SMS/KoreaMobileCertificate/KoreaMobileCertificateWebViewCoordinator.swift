// 
//  KoreaMobileCertificateWebViewCoordinator.swift
//
//  Created by Den Jo on 2021/08/20.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

final class KoreaMobileCertificateWebViewCoordinator: NSObject {
    
    // MARK: - Value
    // MARK: Public
    let view: KoreaMobileCertificateWebView
    
    // MARK: Private
    private var subscriber: AnyCancellable? = nil
    
    
    // MARK: - Initializer
    init(webView: KoreaMobileCertificateWebView) {
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
extension KoreaMobileCertificateWebViewCoordinator: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        log(.info, navigationAction.request.debugDescription)
        
        preferences.preferredContentMode = .mobile
        decisionHandler(.allow, preferences)
        
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies {
            log(.info, $0)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url, let serviceURL = ServiceURL(url: url) else {
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
            }
            
            return
        }
        
        switch serviceURL {
        case .koreaMobileCertificatePass:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && Host.koreaMobileCertification.rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    do {
                        let response = try KoreaMobileCertificateResponse(value: value, cookie: cookie)
                        self.view.data.webViewResponsePublisher.send(response)
                        
                    } catch {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(error))
                    }
                }
            }
            
        case .koreaMobileCertificateMethod:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && Host.koreaMobileCertification.rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    do {
                        let response = try KoreaMobileCompanyResponse(value: value, cookie: cookie)
                        self.view.data.webViewResponsePublisher.send(response)
                        
                    } catch {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(error))
                    }
                }
            }
            
        case .koreaMobileCertificateSMS:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && Host.koreaMobileCertification.rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    do {
                        let response = try KoreaMobileCertificateSMSResponse(value: value, cookie: cookie)
                        self.view.data.webViewResponsePublisher.send(response)
                        
                    } catch {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(error))
                    }
                }
            }
            
        case .koreaMobileCertificateAuthenticationCodeTimer:
            webView.evaluateJavaScript("document.body.innerHTML") { value, error in
                log(.info, "\(webView.url?.description ?? "")\n\(value as? String ?? "")")
                
                WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                    guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && Host.koreaMobileCertification.rawValue.contains($0.domain) }).first else {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                        return
                    }
                    
                    do {
                        let response = try KoreaMobileCertificateAuthenticationCodeResponse(value: value, cookie: cookie)
                        self.view.data.webViewResponsePublisher.send(response)
                        
                    } catch {
                        self.view.data.webViewResponsePublisher.send(completion: .failure(error))
                    }
                }
            }
            
        case .openBankingAuthorizationAccount:
            WKWebsiteDataStore.default().httpCookieStore.getAllCookies { cookies in
                guard let cookie = cookies.filter ({ $0.name == "JSESSIONID" && Host.koreaMobileCertification.rawValue.contains($0.domain) }).first else {
                    self.view.data.webViewResponsePublisher.send(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                
                let response = KoreaMobileCertificateAuthenticationCodeConfirmationResponse(cookie: cookie)
                self.view.data.webViewResponsePublisher.send(response)
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
}
