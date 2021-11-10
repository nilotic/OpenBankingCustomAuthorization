// 
//  OpenBankingAPIServer.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum OpenBankingAPIServer {
    case development
    case stage
    case production
}

extension OpenBankingAPIServer {
    
    init(server: AccounzServer) {
        switch server {
        case .development:  self = .development
        case .stage:        self = .stage
        case .production:   self = .production
        }
    }
}

extension OpenBankingAPIServer {
    
    var rawValue: String {
        switch self {
        #if DEBUG
        case .development:  return "https://testapi.openbanking.or.kr"
        case .stage:        return "https://testapi.openbanking.or.kr"
        case .production:   return "https://api.openbanking.or.kr"
        
        #else
        default:            return "https://api.openbanking.or.kr"
        #endif
        }
    }
}

extension OpenBankingAPIServer: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension OpenBankingAPIServer: CustomDebugStringConvertible {
    
    var debugDescription: String {
        #if DEBUG
        switch self {
        case .development:  return "Development server"
        case .stage:        return "Stage server"
        case .production:   return "Production server"
        }
        
        #else
        return ""
        #endif
    }
}
