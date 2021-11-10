// 
//  OpenBankingUserAuthorizationType.swift
//
//  Created by Den Jo on 2021/08/17.
//  Copyright © finddy Inc. All rights reserved.
//
// https://developers.kftc.or.kr/dev/doc/open-banking
//

import Foundation

enum OpenBankingUserAuthorizationType: Int, Encodable {
    case first = 0
    case skip  = 2
}
