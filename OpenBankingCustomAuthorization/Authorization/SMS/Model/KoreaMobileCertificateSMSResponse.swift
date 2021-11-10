// 
//  KoreaMobileCertificateSMSResponse.swift
//
//  Created by Den Jo on 2021/08/23.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCertificateSMSResponse {
    let requestInfo: String
    let seedKey: String
    let encryptionVersion: String
    let returnURL: String
    let isChromeOniOSRequested: Bool
    let isCloseButtonHide: String
    let closeButtonLink: String
    let retry: String
    let cookie: HTTPCookie
}

extension KoreaMobileCertificateSMSResponse {
    
    private enum Key: String, CodingKey {
        case requestInfo              = "reqInfo"
        case seedKey
        case encryptionVersion        = "encVersion"
        case returnURL
        case retry
        case isChromeOniOSRequested   = "reqCriOSYn"
        case isCloseButtonHide        = "closeBtnHide"
        case closeButtonLink          = "closeBtnLink"
    }
    
    init(value: Any?, cookie: HTTPCookie) throws {
        guard let htmlString = value as? String,
              let regularExpression = try? NSRegularExpression(pattern: "<form name=\"reqForm\" method=\"post\" action=\"https://www.kmcert.com/kmcis/mobile_v3/kmcisSms02.jsp\">(?:\".*?\"|\'.*?\'|[^\'\"])*?</form>", options: [.dotMatchesLineSeparators]),
              let range = regularExpression.matches(in: htmlString, options: [], range: NSMakeRange(0, htmlString.count)).map({ $0.range }).first else {
                  throw URLError(.badServerResponse)
              }
    
        let form = (htmlString as NSString).substring(with: range)
        self.cookie = cookie
        
        let value = { (key: Key) -> String? in
            guard let regularExpression = try? NSRegularExpression(pattern: "name=\"\(key.rawValue)\"\\s*value=(?:\".*?\"|\'.*?\'|[^\'\"])*?>", options: [.dotMatchesLineSeparators]),
                  let range = regularExpression.matches(in: form, options: [], range: NSMakeRange(0, form.count)).map({ $0.range }).first,
                  var value = (form as NSString).substring(with: range).components(separatedBy: "value=").last else {
                      return nil
                  }
            
            value = value.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: ">", with: "")
            return value
        }
       
        guard let requestInfo = value(.requestInfo) else { throw URLError(.badServerResponse) }
        self.requestInfo = requestInfo
        
        guard let seedKey = value(.seedKey) else { throw URLError(.badServerResponse) }
        self.seedKey = seedKey
        
        guard let encryptionVersion = value(.encryptionVersion) else { throw URLError(.badServerResponse) }
        self.encryptionVersion = encryptionVersion
        
        guard let returnURL = value(.returnURL) else { throw URLError(.badServerResponse) }
        self.returnURL = returnURL
        
        guard let isChromeOniOSRequested = value(.isChromeOniOSRequested) else { throw URLError(.badServerResponse) }
        self.isChromeOniOSRequested = isChromeOniOSRequested == "Y" ? true : false
        
        guard let isCloseButtonHide = value(.isCloseButtonHide) else { throw URLError(.badServerResponse) }
        self.isCloseButtonHide = isCloseButtonHide
        
        guard let closeButtonLink = value(.closeButtonLink) else { throw URLError(.badServerResponse) }
        self.closeButtonLink = closeButtonLink
        
        guard let retry = value(.retry) else { throw URLError(.badServerResponse) }
        self.retry = retry
    }
}
