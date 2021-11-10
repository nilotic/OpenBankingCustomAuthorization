// 
//  OpenBankingARSResponse.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingARSResponse {
    let cookie: HTTPCookie
}

extension OpenBankingARSResponse {
    
    init(value: Any?, cookie: HTTPCookie) throws {
        guard let htmlString = value as? String,
              let regularExpression = try? NSRegularExpression(pattern: "<form name=\"frm\" id=\"frm\" method=\"post\">(?:\".*?\"|\'.*?\'|[^\'\"])*?</form>", options: [.dotMatchesLineSeparators]),
              let range = regularExpression.matches(in: htmlString, options: [], range: NSMakeRange(0, htmlString.count)).map({ $0.range }).first else {
                  throw URLError(.badServerResponse)
              }
    
        guard !(htmlString as NSString).substring(with: range).isEmpty else {
            throw URLError(.badServerResponse)
        }
        
        self.cookie = cookie
    }
}
