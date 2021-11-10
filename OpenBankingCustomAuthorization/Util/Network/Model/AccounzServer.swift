// 
//  AccounzServer.swift
//
//  Created by Den Jo on 2021/07/26.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

var server: AccounzServer = .development {
    didSet {
        UserDefaults(suiteName: "")?.set(server.rawValue, forKey: "")
        UserDefaults(suiteName: "")?.synchronize()
    }
}

enum AccounzServer {
    case development
    case stage
    case production
}

extension AccounzServer {
    
    var rawValue: String {
        switch self {
        #if DEBUG
//        case .development:  return "https://api.development.accounz.io"
        case .development:  return "https://api.mocki.io/v2/cd0694db"
        case .stage:        return "https://api.stage.accounz.io"
        case .production:   return "https://api.accounz.io"
        
        #else
        default:            return "https://api.accounz.io"
        #endif
        }
    }
}

extension AccounzServer: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension AccounzServer: CustomDebugStringConvertible {
    
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
