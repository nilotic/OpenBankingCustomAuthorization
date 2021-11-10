// 
//  KoreaMobileVirtualNetworkOperator.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum KoreaMobileVirtualNetworkOperator {
    case none
    case skTelecom
    case kt
    case lgUPlus
}

extension KoreaMobileVirtualNetworkOperator {
    
    var rawValue: String {
        switch self {
        case .none:         return "koreaMobileVirtualNetworkOperator"
        case .skTelecom:    return "sktKoreaMobileVirtualNetworkOperator"
        case .kt:           return "ktKoreaMobileVirtualNetworkOperator"
        case .lgUPlus:      return "lgUPlusKoreaMobileVirtualNetworkOperator"
        }
    }
    
    var description: String {
        switch self {
        case .none:         return "알뜰폰"
        case .skTelecom:    return "SKT 알뜰폰"
        case .kt:           return "KT 알뜰폰"
        case .lgUPlus:      return "LG U+ 알뜰폰"
        }
    }
    
    var companies: String {
        switch self {
        case .none:
            return ""
            
        case .skTelecom:
            return "아이즈비전(아이즈모바일), 유니컴즈(모빙), 스마텔 (스마텔), 에스원(안심모바일), LG헬로비전(헬로모바일), 티플러스(티플러스), 이야기모바일(이야기모바일), SK세븐모바일(SK세븐모바일), 아마트알뜰폰(아마트알뜰폰), 프리티(프리티), 조이텔(조이텔), 마이월드(마이월드)"
            
        case .kt:
            return "LG헬로비전(헬로모바일), KT파워텔(주)(더블비), 홈플러스(주)(플러스모바일), (주)씨엔커뮤니케이션(WMVNO), (주)에넥스텔레콤(WHOM), (주)에스원(안심폰), (주)위너스텔(Well), 에이씨앤코리아(Flash모바일), (주)세종텔레콤(스노우맨), (주)KT텔레캅(KT텔레캅), (주)프리텔레콤(freeT), (주)EG모바일(EG제로), (주)KT M모바일(M모바일), (주)앤알커뮤니케이션(앤텔레콤), (주)아이즈비전(아이즈모바일), (주)제이씨티(제이씨티), (주)머천드코리아(마이월드), 장성모바일(장성모바일), (주)유니컴즈(Mobing), 아이원(아이플러스유), (주)파인디지털(파인디지털), (주)미니게이트(미니게이트), (주)핀플레이(핀플레이), 드림라인(주)(드림라인(주)), (주)한국케이블텔레콤(KCT), 와이엘랜드(여유텔레콤), 큰사람(이야기알뜰폰)(GHS), (주)니즈텔레콤(NZT)"
            
        case .lgUPlus:
            return "(주)미디어로그(U+알뜰모바일), (주)인스코비(freeT), 머천드코리아(마이월드), (주)엠티티텔레콤(메리큐), (주)이마트(이마트알뜰폰), 서경방송(서경휴대폰), 울산중앙방송(JCN알뜰폰), 남인천방송(mfun), 금강방송(kcn알뜰폰), 제주방송(KCTV알뜰폰), 푸른방송(푸른방송), 와이엘랜드(여유텔레콤), 에이씨엔코리아(Flash 모바일), 이지모바일(이지모바일), 유니컴즈(모빙), 큰사람(이야기), 스마텔(스마텔), 에넥스텔레콤(A모바일), 레그원(온국민폰), 드림에이치앤비(셀모바일), 조이텔(조이텔), 에스원(안심모바일), 원텔레콤(원텔레콤), (주)국민은행(Liiv M), LG헬로비전(헬로모바일), 엔티온텔레콤(주)(NTO), 인스모바일(인스모바일)"
        }
    }
}

extension KoreaMobileVirtualNetworkOperator: CaseIterable {
    
    static var allCases: [KoreaMobileVirtualNetworkOperator] = [.skTelecom, .kt, .lgUPlus]
}

extension KoreaMobileVirtualNetworkOperator: Identifiable {
    
    var id: String {
        rawValue
    }
}

extension KoreaMobileVirtualNetworkOperator: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension KoreaMobileVirtualNetworkOperator: Equatable {
    
    static func ==(lhs: KoreaMobileVirtualNetworkOperator, rhs: KoreaMobileVirtualNetworkOperator) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}

