// 
//  KoreaGender.swift
//
//  Created by Den Jo on 2021/08/20.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum KoreaGender {
    case none
    case male(KoreaGenderCentury)
    case female(KoreaGenderCentury)
}

extension KoreaGender {
    
    init(string: String) {
        switch Int(string) ?? -1  {
        case 0:     self = .male(.ninetieth)
        case 9:     self = .female(.ninetieth)
        
        case 1:     self = .male(.twentieth)
        case 2:     self = .female(.twentieth)
        
        case 3:     self = .male(.twentyFirst)
        case 4:     self = .female(.twentyFirst)
        
        case 5:     self = .male(.twentySecond)
        case 6:     self = .female(.twentySecond)
        
        case 7:     self = .male(.twentyThird)
        case 8:     self = .female(.twentyThird)
        
        default:    self = .none
        }
    }
}

extension KoreaGender {
    
    var rawValue: Int {
        switch self {
        case .male(.ninetieth):         return 0
        case .female(.ninetieth):       return 9
            
        case .male(.twentieth):         return 1
        case .female(.twentieth):       return 2
            
        case .male(.twentyFirst):       return 3
        case .female(.twentyFirst):     return 4
            
        case .male(.twentySecond):      return 5
        case .female(.twentySecond):    return 6
            
        case .male(.twentyThird):       return 7
        case .female(.twentyThird):     return 8
            
        default:                        return -1
        }
    }
}

extension KoreaGender: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var contrainer = encoder.singleValueContainer()
        try contrainer.encode(self.rawValue)
    }
}

extension KoreaGender: Identifiable {
    
    var id: Int {
        rawValue
    }
}

extension KoreaGender: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension KoreaGender: Equatable {
    
    static func ==(lhs: KoreaGender, rhs: KoreaGender) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}
