// 
//  OpenBankingTokenResponse.swift
//
//  Created by Den Jo on 2021/08/25.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI

struct OpenBankingTokenResponse {
    let accessToken: String
    let tokenType: String
    let expiresIn: TimeInterval
    let refreshToken: String
    let userSequenceNumber: String
    let scopes: [OpenBankingAuthorizationScope]
}

extension OpenBankingTokenResponse: Decodable {
    
    private enum Key: String, CodingKey {
        case accessToken        = "access_token"
        case tokenType          = "token_type"
        case expiresIn          = "expires_in"
        case refreshToken       = "refresh_token"
        case userSequenceNumber = "user_seq_no"
        case scopes             = "scope"
    }
 
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
    
        do { accessToken        = try container.decode(String.self,       forKey: .accessToken) }        catch { throw error }
        do { tokenType          = try container.decode(String.self,       forKey: .tokenType) }          catch { throw error }
        do { expiresIn          = try container.decode(TimeInterval.self, forKey: .expiresIn) }          catch { throw error }
        do { refreshToken       = try container.decode(String.self,       forKey: .refreshToken) }       catch { throw error }
        do { userSequenceNumber = try container.decode(String.self,       forKey: .userSequenceNumber) } catch { throw error }
        
        do {
            let scopes = try container.decode(String.self, forKey: .scopes)
            self.scopes = scopes.components(separatedBy: " ").compactMap { OpenBankingAuthorizationScope(rawValue: $0) }
        
        } catch { throw error }
    }
}
