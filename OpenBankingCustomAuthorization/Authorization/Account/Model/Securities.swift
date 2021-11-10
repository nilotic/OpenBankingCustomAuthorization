// 
//  Securities.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI

enum Securities: UInt, Encodable, CaseIterable {
    case none                    = 0
    case nhSecurities            = 247
    case kyoboSecurities         = 261
    case daishinSecurities       = 267
    case meritzSecurities        = 287
    case miraeAssetSecurities    = 238
    case bookookSecurities       = 290
    case samsungSecurities       = 240
    case shinyoungSecurities     = 291
    case shinhanSecurities       = 278
    case imSecurities            = 268
    case yuantaSecurities        = 209
    case eugeneSecurities        = 280
    case eBestSecurities         = 265
    case kakaoPaySecurities      = 288
    case capeSecurities          = 292
    case kiwoomSecurities        = 264
    case tossSecurities          = 271
    case hanaSecurities          = 270
    case hiSecurities            = 262
    case koreaSecurities         = 243
    case fossKoreaSecurities     = 294
    case hanhwaSecurities        = 269
    case hyundaiMotorSecurities  = 263
    case bnkSecurities           = 224
    case dbSecurities            = 279
    case ibkSecurities           = 225
    case kbSecurities            = 218
    case ktbSecurities           = 227
    case skSecurities            = 266
}

extension Securities {
    
    var name: String {
        switch self {
        case .none:                         return ""
        case .nhSecurities:                 return "NH투자증권"
        case .kyoboSecurities:              return "교보증권"
        case .daishinSecurities:            return "대신증권"
        case .meritzSecurities:             return "메리츠증권"
        case .miraeAssetSecurities:         return "미래에셋증권"
        case .bookookSecurities:            return "부국증권"
        case .samsungSecurities:            return "삼성증권"
        case .shinyoungSecurities:          return "신영증권"
        case .shinhanSecurities:            return "신한금융투자"
        case .imSecurities:                 return "아이엠투자증권"
        case .yuantaSecurities:             return "유안타증권"
        case .eugeneSecurities:             return "유진투자증권"
        case .eBestSecurities:              return "이베스트투자증권"
        case .kakaoPaySecurities:           return "카카오페이증권"
        case .capeSecurities:               return "케이프투자증권"
        case .kiwoomSecurities:             return "키움증권"
        case .tossSecurities:               return "토스증권"
        case .hanaSecurities:               return "하나금융투자"
        case .hiSecurities:                 return "하이투자증권"
        case .koreaSecurities:              return "한국투자증권"
        case .fossKoreaSecurities:          return "한국포스증권"
        case .hanhwaSecurities:             return "한화투자증권"
        case .hyundaiMotorSecurities:       return "현대차증권"
        case .bnkSecurities:                return "BNK증권"
        case .dbSecurities:                 return "DB금융투자"
        case .ibkSecurities:                return "IBK투자증권"
        case .kbSecurities:                 return "KB증권"
        case .ktbSecurities:                return "KTB투자증권"
        case .skSecurities:                 return "SK증권"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .none:                         return nil
        case .nhSecurities:                 return UIImage(named: "nhSecurities")
        case .kyoboSecurities:              return UIImage(named: "kyoboSecurities")
        case .daishinSecurities:            return UIImage(named: "daishinSecurities")
        case .meritzSecurities:             return UIImage(named: "meritzSecurities")
        case .miraeAssetSecurities:         return UIImage(named: "miraeAssetSecurities")
        case .bookookSecurities:            return UIImage(named: "bookookSecurities")
        case .samsungSecurities:            return UIImage(named: "samsungSecurities")
        case .shinyoungSecurities:          return UIImage(named: "shinyoungSecurities")
        case .shinhanSecurities:            return UIImage(named: "shinhanSecurities")
        case .imSecurities:                 return UIImage(named: "imSecurities")
        case .yuantaSecurities:             return UIImage(named: "yuantaSecurities")
        case .eugeneSecurities:             return UIImage(named: "eugeneSecurities")
        case .eBestSecurities:              return UIImage(named: "eBestSecurities")
        case .kakaoPaySecurities:           return UIImage(named: "kakaoPaySecurities")
        case .capeSecurities:               return UIImage(named: "capeSecurities")
        case .kiwoomSecurities:             return UIImage(named: "kiwoomSecurities")
        case .tossSecurities:               return UIImage(named: "tossSecurities")
        case .hanaSecurities:               return UIImage(named: "hanaSecurities")
        case .hiSecurities:                 return UIImage(named: "hiSecurities")
        case .koreaSecurities:              return UIImage(named: "koreaSecurities")
        case .fossKoreaSecurities:          return UIImage(named: "fossKoreaSecurities")
        case .hanhwaSecurities:             return UIImage(named: "hanhwaSecurities")
        case .hyundaiMotorSecurities:       return UIImage(named: "hyundaiMotorSecurities")
        case .bnkSecurities:                return UIImage(named: "bnkSecurities")
        case .dbSecurities:                 return UIImage(named: "dbSecurities")
        case .ibkSecurities:                return UIImage(named: "ibkSecurities")
        case .kbSecurities:                 return UIImage(named: "kbSecurities")
        case .ktbSecurities:                return UIImage(named: "ktbSecurities")
        case .skSecurities:                 return UIImage(named: "skSecurities")
        }
    }
}

extension Securities: Identifiable {
    
    var id: UInt {
        rawValue
    }
}

extension Securities: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Securities: Equatable {
    
    static func ==(lhs: Securities, rhs: Securities) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
