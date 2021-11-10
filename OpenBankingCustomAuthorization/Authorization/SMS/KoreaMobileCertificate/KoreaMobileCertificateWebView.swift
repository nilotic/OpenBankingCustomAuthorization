// 
//  KoreaMobileCertificateWebView.swift
//
//  Created by Den Jo on 2021/08/20.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

struct KoreaMobileCertificateWebView {
    
    // MARK: - Value
    // MARK: Public
    @EnvironmentObject var data: SMSAuthenticationData
    let webView: WKWebView
    
    
    // MARK: - Initializer
    init() {
        var configuration: WKWebViewConfiguration {
            let preferences = WKWebpagePreferences()
            preferences.allowsContentJavaScript = true
            
            let configuration = WKWebViewConfiguration()
            configuration.defaultWebpagePreferences = preferences
            
            return configuration
        }
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .clear
    }
}


// MARK: UIView Representable
extension KoreaMobileCertificateWebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> KoreaMobileCertificateWebViewCoordinator {
        KoreaMobileCertificateWebViewCoordinator(webView: self)
    }
}
