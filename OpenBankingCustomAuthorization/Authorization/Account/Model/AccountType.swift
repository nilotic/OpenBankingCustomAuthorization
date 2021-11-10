// 
//  AccountType.swift
//
//  Created by Den Jo on 2021/08/06.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum AccountType {
    case none
    case bank(Bank)
    case securities(Securities)
}

extension AccountType {
    
    var rawValue: UInt {
        switch self {
        case .none:                         return 0
        case .bank(let bank):               return bank.rawValue
        case .securities(let securities):   return securities.rawValue
        }
    }
    
    var description: String {
        switch self {
        case .none:                         return ""
        case .bank(let bank):               return bank.name
        case .securities(let securities):   return securities.name
        }
    }
}

extension AccountType: Encodable {
        
    func encode(to encoder: Encoder) throws {
        var contrainer = encoder.singleValueContainer()
        
        switch self {
        case .none:                         break
        case .bank(let bank):               try contrainer.encode(bank.rawValue)
        case .securities(let securities):   try contrainer.encode(securities.rawValue)
        }
    }
}
    
extension AccountType: CaseIterable {
    
    static var allCases: [AccountType] = [.bank(.none),         .bank(.wooriBank),    .bank(.kbBank),        .bank(.ibk),
                                          .bank(.nhBank),       .bank(.shinhanBank),  .bank(.hanaBank),      .bank(.citiBank),
                                          .bank(.scBank),       .bank(.kyongnamBank), .bank(.kwangjuBank),   .bank(.daeguBank),
                                          .bank(.deutscheBank), .bank(.busanBank),    .bank(.bnpParibas),    .bank(.nfcf),
                                          .bank(.kdb),          .bank(.kfoccc),       .bank(.eibok),         .bank(.suhyupBank),
                                          .bank(.sinhyupBank),  .bank(.koreaPost),    .bank(.savingBank),    .bank(.jeonbukBank),
                                          .bank(.jejuBank),     .bank(.ccb),          .bank(.icbc),          .bank(.boc),
                                          .bank(.nacf),         .bank(.kakaoBank),    .bank(.kBank),         .bank(.tossBank),
                                          .bank(.boa),          .bank(.hsbc),         .bank(.jpMorganChase), .bank(.sbiSavingBank),
                                          
                                          .securities(.nhSecurities),         .securities(.kyoboSecurities),    .securities(.daishinSecurities),      .securities(.meritzSecurities),
                                          .securities(.miraeAssetSecurities), .securities(.bookookSecurities),  .securities(.samsungSecurities),      .securities(.shinyoungSecurities),
                                          .securities(.shinhanSecurities),    .securities(.imSecurities),       .securities(.yuantaSecurities),       .securities(.eugeneSecurities),
                                          .securities(.eBestSecurities),      .securities(.kakaoPaySecurities), .securities(.capeSecurities),         .securities(.kiwoomSecurities),
                                          .securities(.tossSecurities),       .securities(.hanaSecurities),     .securities(.hiSecurities),           .securities(.koreaSecurities),
                                          .securities(.fossKoreaSecurities),  .securities(.hanhwaSecurities),   .securities(.hyundaiMotorSecurities), .securities(.bnkSecurities),
                                          .securities(.dbSecurities),         .securities(.ibkSecurities),      .securities(.kbSecurities),           .securities(.ktbSecurities),
                                          .securities(.skSecurities)]
}

extension AccountType: Identifiable {
    
    var id: UInt {
        rawValue
    }
}

extension AccountType: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension AccountType: Equatable {
    
    static func ==(lhs: AccountType, rhs: AccountType) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
