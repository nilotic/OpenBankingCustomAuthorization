// 
//  OpenBankingAuthorizationPoliciesRequest.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingAuthorizationPoliciesRequest {
    let redirectURL: URL?
    
    private let device = ""
    private let type   = ""
}

extension OpenBankingAuthorizationPoliciesRequest: Encodable {
    
    private enum Key: String, CodingKey {
        case redirectURL = "redirect_uri"
        case type
        case device
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(redirectURL, forKey: .redirectURL) } catch { throw error }
        do { try container.encode(device,      forKey: .device) }      catch { throw error }
        do { try container.encode(type,        forKey: .type) }        catch { throw error }
    }
}
