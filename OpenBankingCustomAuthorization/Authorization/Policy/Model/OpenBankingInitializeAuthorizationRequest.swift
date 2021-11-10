// 
//  OpenBankingInitializeAuthorizationRequest.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingInitializeAuthorizationRequest {
    let state: String
    let isAccountAuthorization: Bool
    let scopes: [OpenBankingAuthorizationScope]
    let userAuthorizationType: OpenBankingUserAuthorizationType
    let authorizationType: OpenBankingAuthorizationType

    private let clientID     = "048a8bef-be09-4f07-8a8f-bf0b7e388c71"
    private let redirectURL  = ServiceURL.openBankingCallBack.rawValue
    private let responseType = "code"
}

extension OpenBankingInitializeAuthorizationRequest: Encodable {

    private enum Key: String, CodingKey {
        case clientID                   = "client_id"
        case redirectURL                = "redirect_uri"
        case state
        case responseType               = "response_type"
        case isAccountAuthorization     = "account_hold_auth_yn"
        case scopes                     = "scope"
        case userAuthorizationType      = "auth_type"
        case isMobileAuthorization      = "cellphone_cert_yn"
        case isCertificateAuthorization = "authorized_cert_yn"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(clientID,     forKey: .clientID) }     catch { throw error }
        do { try container.encode(redirectURL,  forKey: .redirectURL) }  catch { throw error }
        do { try container.encode(responseType, forKey: .responseType) } catch { throw error }
        do { try container.encode(state,        forKey: .state) }        catch { throw error }
        
        
        // Account authorization
        do { try container.encode(isAccountAuthorization ? "Y" : "N", forKey: .isAccountAuthorization) } catch { throw error }
        
        
        // Scopes
        let scopes = scopes.reduce("") { $0 + "\($0 == "" ? "" : " ")" + $1.rawValue }
        do { try container.encode(scopes, forKey: .scopes) }  catch { throw error }
            
        
        // User authorization type
        do { try container.encode("\(userAuthorizationType.rawValue)", forKey: .userAuthorizationType) } catch { throw error }
        
        do {
            switch authorizationType {
            case .mobile:
                try container.encode("Y", forKey: .isMobileAuthorization)
                try container.encode("N", forKey: .isCertificateAuthorization)
            
            case .certificate:
                try container.encode("N", forKey: .isCertificateAuthorization)
                try container.encode("Y", forKey: .isCertificateAuthorization)
            }
            
        } catch { throw error }
    }
}
