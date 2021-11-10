// 
//  OpenBankingCallConfirmationResponse.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingCallConfirmationResponse {
    let code: String
    let scopes: [OpenBankingAuthorizationScope]
    let state: String
    let cookie: HTTPCookie
}

extension OpenBankingCallConfirmationResponse {
    
    private enum Key: String, CodingKey {
        case code
        case scopes = "scope"
        case state
    }
    
    init(url: URL?, cookie: HTTPCookie) throws {
        guard let url = url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else { throw URLError(.badServerResponse) }
        self.cookie = cookie
        
        // Query
        let items = queryItems.reduce([String: String]()) { result, item in
            var result = result
            if let value = item.value {
                result[item.name] = value
            }
            
            return result
        }
        
        guard let code = items[Key.code.rawValue] else { throw URLError(.badServerResponse) }
        self.code = code
        
        guard let scopes = items[Key.scopes.rawValue] else { throw URLError(.badServerResponse) }
        self.scopes = scopes.components(separatedBy: " ").compactMap { OpenBankingAuthorizationScope(rawValue: $0) }
        
        guard let state = items[Key.state.rawValue] else { throw URLError(.badServerResponse) }
        self.state = state
    }
}
