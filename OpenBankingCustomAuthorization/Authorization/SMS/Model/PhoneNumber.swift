// 
//  PhoneNumber.swift
//
//  Created by Den Jo on 2021/09/06.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Contacts

struct PhoneNumber: Codable {
    var countryCallingCode = ""
    var digits             = ""
}

extension PhoneNumber {
    
    init?(data: CNPhoneNumber?) {
        guard let data = data, let countryCallingCode = LocaleManager.callingCode(from: data.value(forKey: "countryCode") as? String), let digits = data.value(forKey: "digits") as? String else { return nil }
        self.countryCallingCode = countryCallingCode
        self.digits = digits
    }
}

extension PhoneNumber {
    
    var nationalConvetionPhoneNumber: String? {
        guard !countryCallingCode.isEmpty else { return nil }
        return "+\(countryCallingCode) \(digits)"
    }
    
    var rawValue: String {
        "\(countryCallingCode)\(digits)"
    }
}

extension PhoneNumber: Identifiable {
    
    var id: String {
        rawValue
    }
}

extension PhoneNumber: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension PhoneNumber: Equatable {
    
    static func ==(lhs: PhoneNumber, rhs: PhoneNumber) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
}


#if DEBUG
extension PhoneNumber {
    
    static var placeholder: PhoneNumber {
        PhoneNumber(countryCallingCode: "82", digits: "010-6354-1696")
    }
}
#endif
