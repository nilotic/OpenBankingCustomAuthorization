// 
//  KoreaMobileCarrier.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum KoreaMobileCarrier {
    case none
    case skTelecom
    case kt
    case lgUPlus
    case koreaMobileVirtualNetworkOperator(KoreaMobileVirtualNetworkOperator)
}

extension KoreaMobileCarrier {
    
    var rawValue: String {
        switch self {
        case .none:         return "koreaMobileCompany"
        case .skTelecom:    return "sktKoreaMobileCompany"
        case .kt:           return "ktKoreaMobileCompany"
        case .lgUPlus:      return "lgUPlusKoreaMobileCompany"
        
        case .koreaMobileVirtualNetworkOperator(let koreaMobileVirtualNetworkOperator):
            return koreaMobileVirtualNetworkOperator.rawValue
        }
    }
    
    var description: String {
        switch self {
        case .none:         return ""
        case .skTelecom:    return "SKT"
        case .kt:           return "KT"
        case .lgUPlus:      return "LG U+"
            
        case .koreaMobileVirtualNetworkOperator(let koreaMobileVirtualNetworkOperator):
            return koreaMobileVirtualNetworkOperator.description
        }
    }
}

extension KoreaMobileCarrier: Encodable {
        
    func encode(to encoder: Encoder) throws {
        var contrainer = encoder.singleValueContainer()
        
        switch self {
        case .none:         break
        case .skTelecom:    try contrainer.encode("SKT")
        case .kt:           try contrainer.encode("KTF")
        case .lgUPlus:      try contrainer.encode("LGT")
            
        case .koreaMobileVirtualNetworkOperator:
            break
        }
    }
}

extension KoreaMobileCarrier: CaseIterable {
    
    static var allCases: [KoreaMobileCarrier] = [.none, .skTelecom, .kt, .lgUPlus, .koreaMobileVirtualNetworkOperator(.none)]
}

extension KoreaMobileCarrier: Identifiable {
    
    var id: String {
        rawValue
    }
}

extension KoreaMobileCarrier: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension KoreaMobileCarrier: Equatable {
    
    static func ==(lhs: KoreaMobileCarrier, rhs: KoreaMobileCarrier) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
