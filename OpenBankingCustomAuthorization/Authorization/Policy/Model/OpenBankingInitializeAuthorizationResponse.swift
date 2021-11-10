// 
//  OpenBankingInitializeAuthorizationResponse.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingInitializeAuthorizationResponse {
    let sessionID: String
    let action: String
    let transactionID: String
    let gatewaySwitchedVirtualCircuitID: String
    let gatewayApplicationKey: String
    let responseType: String
    let clientID: String
    let clientInfo: String?
    let referer: URL
    let redirectURL: URL?
    let cookie: HTTPCookie
}

extension OpenBankingInitializeAuthorizationResponse {
    
    private enum Key: String, CodingKey {
        case sessionID
        case action
        case transactionID                   = "api_tran_id"
        case gatewaySwitchedVirtualCircuitID = "gw_svc_id"
        case gatewayApplicationKey           = "gw_app_key"
        case responseType                    = "response_type"
        case clientID                        = "client_id"
        case clientInfo                      = "client_info"
        case redirectURL                     = "redirect_uri"
    }
    
    init(url: URL, cookie: HTTPCookie) throws {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else { throw URLError(.badServerResponse) }
        self.cookie = cookie
        
        // Query
        let items = queryItems.reduce([String: String]()) { result, item in
            var result = result
            if let value = item.value {
                result[item.name] = value
            }
            
            return result
        }
        
        guard let sessionID = items[Key.sessionID.rawValue] else { throw URLError(.badServerResponse) }
        self.sessionID = sessionID
        
        guard let action = items[Key.action.rawValue] else { throw URLError(.badServerResponse) }
        self.action = action
        
        guard let transactionID = items[Key.transactionID.rawValue] else { throw URLError(.badServerResponse) }
        self.transactionID = transactionID
        
        guard let gatewaySwitchedVirtualCircuitID = items[Key.gatewaySwitchedVirtualCircuitID.rawValue] else { throw URLError(.badServerResponse) }
        self.gatewaySwitchedVirtualCircuitID = gatewaySwitchedVirtualCircuitID
        
        guard let gatewayApplicationKey = items[Key.gatewayApplicationKey.rawValue] else { throw URLError(.badServerResponse) }
        self.gatewayApplicationKey = gatewayApplicationKey
        
        guard let responseType = items[Key.responseType.rawValue] else { throw URLError(.badServerResponse) }
        self.responseType = responseType
        
        guard let clientID = items[Key.clientID.rawValue] else { throw URLError(.badServerResponse) }
        self.clientID = clientID
        
        self.clientInfo = items[Key.clientInfo.rawValue]
        self.referer    = url
        
        guard let redirectURLString = items[Key.redirectURL.rawValue], let redirectURL = URL(string: redirectURLString) else { throw URLError(.badServerResponse) }
        self.redirectURL = redirectURL
    }
}
