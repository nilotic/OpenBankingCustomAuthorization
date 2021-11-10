// 
//  OpenBankingServer.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum OpenBankingServer {
    case development
    case stage
    case production
}

extension OpenBankingServer {
    
    init(server: AccounzServer) {
        switch server {
        case .development:  self = .development
        case .stage:        self = .stage
        case .production:   self = .production
        }
    }
}

extension OpenBankingServer {
    
    var rawValue: String {
        switch self {
        #if DEBUG
        case .development:  return "https://twww.openbanking.or.kr"
        case .stage:        return "https://twww.openbanking.or.kr"
        case .production:   return "https://www.openbanking.or.kr"
        
        #else
        default:            return "https://www.openbanking.or.kr"
        #endif
        }
    }
}

extension OpenBankingServer: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension OpenBankingServer: CustomDebugStringConvertible {
    
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
