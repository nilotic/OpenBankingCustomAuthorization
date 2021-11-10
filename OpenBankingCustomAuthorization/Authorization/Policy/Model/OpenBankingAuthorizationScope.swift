// 
//  OpenBankingAuthorizationScope.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

enum OpenBankingAuthorizationScope: String, Codable {
    case logIn = "login"
    case inquiry
    case transfer
}
