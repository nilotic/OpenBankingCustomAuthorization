// 
//  OpenBankingCallResponse.swift
//
//  Created by Den Jo on 2021/08/25.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingCallResponse {
    let cookie: HTTPCookie
}

extension OpenBankingCallResponse {
    
    init(value: Any?, cookie: HTTPCookie) throws {
        guard let htmlString = value as? String,
              let regularExpression = try? NSRegularExpression(pattern: "<form name=\"frm\" method=\"post\" id=\"frm\" action=\"/apt/cert/getRecordARS\" target=\"\">(?:\".*?\"|\'.*?\'|[^\'\"])*?</form>", options: [.dotMatchesLineSeparators]),
              let range = regularExpression.matches(in: htmlString, options: [], range: NSMakeRange(0, htmlString.count)).map({ $0.range }).first else {
                  throw URLError(.badServerResponse)
              }
    
        guard !(htmlString as NSString).substring(with: range).isEmpty else {
            throw URLError(.badServerResponse)
        }
        
        self.cookie = cookie
    }
}
