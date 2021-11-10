// 
//  KoreaMobileCertificateResponse.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCertificateResponse {
    let requestInfo: String
    let seedKey: String
    let encryptionVersion: String
    let returnURL: String
    let isChromeOniOSRequested: Bool
    let isCloseButtonHide: String
    let closeButtonLink: String
    let retry: String
    let sktBoboRequestInfo: String
    let hpProtectRequestInfo: String
    let hpMyOTPSMSRequestInfo: String
    let hpMngMyOTPSMSRequestInfo: String
    let cookie: HTTPCookie
}

extension KoreaMobileCertificateResponse {
    
    private enum Key: String, CodingKey {
        case requestInfo              = "reqInfo_pass"
        case seedKey                  = "seedKey_pass"
        case encryptionVersion        = "encVersion_pass"
        case returnURL                = "returnURL_pass"
        case retry                    = "retry_pass"
        case isChromeOniOSRequested   = "reqCriOSYn"
        case isCloseButtonHide        = "closeBtnHide"
        case closeButtonLink          = "closeBtnLink"
        case sktBoboRequestInfo       = "sktBohoReqInfo"
        case hpProtectRequestInfo     = "hpProtectReqInfo"
        case hpMyOTPSMSRequestInfo    = "hpMyOTPsmsReqInfo"
        case hpMngMyOTPSMSRequestInfo = "hpMngMyOTPsmsReqInfo"
    }
    
    init(value: Any?, cookie: HTTPCookie) throws {
        guard let htmlString = value as? String,
              let regularExpression = try? NSRegularExpression(pattern: "<form name=\"pageForm\" method=\"post\" action=\"\">(?:\".*?\"|\'.*?\'|[^\'\"])*?</form>", options: [.dotMatchesLineSeparators]),
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
        
        guard let sktBoboRequestInfo = value(.sktBoboRequestInfo) else { throw URLError(.badServerResponse) }
        self.sktBoboRequestInfo = sktBoboRequestInfo
        
        guard let hpProtectRequestInfo = value(.hpProtectRequestInfo) else { throw URLError(.badServerResponse) }
        self.hpProtectRequestInfo = hpProtectRequestInfo
        
        guard let hpMyOTPSMSRequestInfo = value(.hpMyOTPSMSRequestInfo) else { throw URLError(.badServerResponse) }
        self.hpMyOTPSMSRequestInfo = hpMyOTPSMSRequestInfo
        
        guard let hpMngMyOTPSMSRequestInfo = value(.hpMngMyOTPSMSRequestInfo) else { throw URLError(.badServerResponse) }
        self.hpMngMyOTPSMSRequestInfo = hpMngMyOTPSMSRequestInfo
    }
}
