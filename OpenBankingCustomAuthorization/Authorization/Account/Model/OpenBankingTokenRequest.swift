// 
//  OpenBankingTokenRequest.swift
//
//  Created by Den Jo on 2021/08/25.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation


struct OpenBankingTokenRequest {
    let code: String
    
    private let clientID     = "048a8bef-be09-4f07-8a8f-bf0b7e388c71"
    private let clientSecret = "393126bb-952f-4394-a20a-5079ecff6a07"
    private let redirectURL  = ServiceURL.openBankingCallBack.rawValue
    private let grantType    = "authorization_code"
}

extension OpenBankingTokenRequest: Encodable {

    private enum Key: String, CodingKey {
        case code
        case clientID     = "client_id"
        case clientSecret = "client_secret"
        case redirectURL  = "redirect_uri"
        case grantType    = "grant_type"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(code,         forKey: .code) }         catch { throw error }
        do { try container.encode(clientID,     forKey: .clientID) }     catch { throw error }
        do { try container.encode(clientSecret, forKey: .clientSecret) } catch { throw error }
        do { try container.encode(redirectURL,  forKey: .redirectURL) }  catch { throw error }
        do { try container.encode(grantType,    forKey: .grantType) }    catch { throw error }
    }
}
