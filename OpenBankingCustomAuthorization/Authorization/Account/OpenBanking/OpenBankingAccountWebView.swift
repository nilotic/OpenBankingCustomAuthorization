// 
//  OpenBankingAccountWebView.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

struct OpenBankingAccountWebView {
    
    // MARK: - Value
    // MARK: Public
    @EnvironmentObject var data: AuthenticationAccountData
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
extension OpenBankingAccountWebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
    }
    
    func makeCoordinator() -> OpenBankingAccountWebViewCoordinator {
        OpenBankingAccountWebViewCoordinator(webView: self)
    }
}

