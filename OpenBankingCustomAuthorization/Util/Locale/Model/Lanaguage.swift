// 
//  Lanaguage.swift
//
//  Created by Den Jo on 2021/07/26.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct Language: Codable, Equatable {
    let code: String
}

extension Language {
    
    var localizedString: String? {
        Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.languageCode.rawValue: code])).localizedString(forLanguageCode: code)
    }
}
