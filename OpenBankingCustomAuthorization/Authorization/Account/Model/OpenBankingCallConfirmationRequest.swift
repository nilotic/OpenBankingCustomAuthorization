// 
//  OpenBankingCallConfirmationRequest.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingCallConfirmationRequest {
    let email: String
    
    private let mode = "easyMobileWeb"
    private let retInpAcnt = false
}

extension OpenBankingCallConfirmationRequest: Encodable {

    private enum Key: String, CodingKey {
        case email
        case mode
        case retInpAcnt
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(email,      forKey: .email) }      catch { throw error }
        do { try container.encode(mode,       forKey: .mode) }       catch { throw error }
        do { try container.encode(retInpAcnt, forKey: .retInpAcnt) } catch { throw error }
    }
}
