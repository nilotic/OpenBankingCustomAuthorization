// 
//  Bank.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI

enum Bank: UInt, Encodable, CaseIterable {
    case none          = 0
    case wooriBank     = 20
    case kbBank        = 4
    case ibk           = 3
    case nhBank        = 11
    case shinhanBank   = 88
    case hanaBank      = 81
    case citiBank      = 27
    case scBank        = 23
    case kyongnamBank  = 39
    case kwangjuBank   = 34
    case daeguBank     = 31
    case deutscheBank  = 55
    case busanBank     = 32
    case bnpParibas    = 61
    case nfcf          = 64
    case kdb           = 2
    case kfoccc        = 45
    case eibok         = 8
    case suhyupBank    = 7
    case sinhyupBank   = 48
    case koreaPost     = 71
    case savingBank    = 50
    case jeonbukBank   = 37
    case jejuBank      = 35
    case ccb           = 67
    case icbc          = 62
    case boc           = 63
    case nacf          = 12
    case kakaoBank     = 90
    case kBank         = 89
    case tossBank      = 92
    case boa           = 60
    case hsbc          = 54
    case jpMorganChase = 57
    case sbiSavingBank = 103
}

extension Bank {
    
    var name: String {
        switch self {
        case .none:                 return ""
        case .wooriBank:            return "우리은행"
        case .kbBank:               return "국민은행"
        case .ibk:                  return "기업은행"
        case .nhBank:               return "농협은행"
        case .shinhanBank:          return "신한은행"
        case .hanaBank:             return "하나은행"
        case .citiBank:             return "한국씨티은행"
        case .scBank:               return "SC제일은행"
        case .kyongnamBank:         return "경남은행"
        case .kwangjuBank:          return "광주은행"
        case .daeguBank:            return "대구은행"
        case .deutscheBank:         return "도이치은행"
        case .busanBank:            return "부산은행"
        case .bnpParibas:           return "비엔피파리바은행"
        case .nfcf:                 return "산림조합"
        case .kdb:                  return "산업은행"
        case .kfoccc:               return "새마을금고"
        case .eibok:                return "수출입은행"
        case .suhyupBank:           return "수협은행"
        case .sinhyupBank:          return "신협"
        case .koreaPost:            return "우체국"
        case .savingBank:           return "저축은행"
        case .jeonbukBank:          return "전북은행"
        case .jejuBank:             return "제주은행"
        case .ccb:                  return "중국건설은행"
        case .icbc:                 return "중국공상은행"
        case .boc:                  return "중국은행"
        case .nacf:                 return "지역농축협"
        case .kakaoBank:            return "카카오뱅크"
        case .kBank:                return "케이뱅크"
        case .tossBank:             return "토스뱅크"
        case .boa:                  return "BOA(뱅크오프아메리카)"
        case .hsbc:                 return "HSBC은행"
        case .jpMorganChase:        return "JP 모간체이스은행"
        case .sbiSavingBank:        return "SBI저축은행"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .none:                 return nil
        case .wooriBank:            return UIImage(named: "wooriBank")
        case .kbBank:               return UIImage(named: "kbBank")
        case .ibk:                  return UIImage(named: "ibk")
        case .nhBank:               return UIImage(named: "nhBank")
        case .shinhanBank:          return UIImage(named: "shinhanBank")
        case .hanaBank:             return UIImage(named: "hanaBank")
        case .citiBank:             return UIImage(named: "citiBank")
        case .scBank:               return UIImage(named: "scBank")
        case .kyongnamBank:         return UIImage(named: "kyongnamBank")
        case .kwangjuBank:          return UIImage(named: "kwangjuBank")
        case .daeguBank:            return UIImage(named: "daeguBank")
        case .deutscheBank:         return UIImage(named: "deutscheBank")
        case .busanBank:            return UIImage(named: "busanBank")
        case .bnpParibas:           return UIImage(named: "bnpParibas")
        case .nfcf:                 return UIImage(named: "nfcf")
        case .kdb:                  return UIImage(named: "kdb")
        case .kfoccc:               return UIImage(named: "kfoccc")
        case .eibok:                return UIImage(named: "eibok")
        case .suhyupBank:           return UIImage(named: "suhyupBank")
        case .sinhyupBank:          return UIImage(named: "sinhyupBank")
        case .koreaPost:            return UIImage(named: "koreaPost")
        case .savingBank:           return UIImage(named: "savingBank")
        case .jeonbukBank:          return UIImage(named: "jeonbukBank")
        case .jejuBank:             return UIImage(named: "jejuBank")
        case .ccb:                  return UIImage(named: "ccb")
        case .icbc:                 return UIImage(named: "icbc")
        case .boc:                  return UIImage(named: "boc")
        case .nacf:                 return UIImage(named: "nacf")
        case .kakaoBank:            return UIImage(named: "kakaoBank")
        case .kBank:                return UIImage(named: "kBank")
        case .tossBank:             return UIImage(named: "tossBank")
        case .boa:                  return UIImage(named: "boa")
        case .hsbc:                 return UIImage(named: "hsbc")
        case .jpMorganChase:        return UIImage(named: "jpMorganChase")
        case .sbiSavingBank:        return UIImage(named: "jpMorganChase")
        }
    }
}

extension Bank: Identifiable {
    
    var id: UInt {
        rawValue
    }
}

extension Bank: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Bank: Equatable {
    
    static func ==(lhs: Bank, rhs: Bank) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
