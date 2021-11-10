// 
//  KoreaMobileCertificateAuthenticationCodeResponse.swift
//
//  Created by Den Jo on 2021/08/23.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCertificateAuthenticationCodeResponse {
    let requestInfo: String
    let requestInfo1: String
    let requestInfo2: String
    let returnURL: String
    let date: String
    let communicationID: String
    let isCommunicationIDRequested: Bool
    let requestBaseEncryptionC: String
    let requestBaseEncryptionD: String
    let isSKTSMS: Bool
    let sktRequestTransitionID: String
    let sktSMSAuthorizationID: String
    let sktSMSBirthday: String
    let sktAuthorizationResult: String
    let certificate1: String
    let certificate2: String
    let isChromeOniOSRequested: Bool
    let isCloseButtonHide: String
    let closeButtonLink: String
    let cookie: HTTPCookie
}

extension KoreaMobileCertificateAuthenticationCodeResponse {
    
    private enum Key: String, CodingKey {
        case requestInfo                = "reqInfo"
        case requestInfo1               = "reqInfo1"
        case requestInfo2               = "reqInfo2"
        case returnURL
        case date
        case communicationID            = "reqCommIdStated"
        case isCommunicationIDRequested = "reqCommIdStatedYn"
        case requestBaseEncryptionC     = "reqBaseEncC"
        case requestBaseEncryptionD     = "reqBaseEncD"
        case isSKTSMS                   = "strSktSmsConnYn"
        case sktRequestTransitionID     = "strSktSmsReqTransId"
        case sktSMSAuthorizationID      = "strSktSmsAuthTransId"
        case sktSMSBirthday             = "strSktSmsBirth"
        case sktAuthorizationResult     = "strAuthResult"
        case certificate1               = "tr_cert1"
        case certificate2               = "tr_cert2"
        case isChromeOniOSRequested     = "reqCriOSYn"
        case isCloseButtonHide          = "closeBtnHide"
        case closeButtonLink            = "closeBtnLink"
    }
    
    init(value: Any?, cookie: HTTPCookie) throws {
        guard let htmlString = value as? String,
              let regularExpression = try? NSRegularExpression(pattern: "<form name=\"smsInputForm\" method=\"post\" action=\"https://www.kmcert.com/kmcis/mobile_v3/kmcisSms04.jsp\">(?:\".*?\"|\'.*?\'|[^\'\"])*?</form>", options: [.dotMatchesLineSeparators]),
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
        
        guard let requestInfo1 = value(.requestInfo1) else { throw URLError(.badServerResponse) }
        self.requestInfo1 = requestInfo1
        
        guard let requestInfo2 = value(.requestInfo2) else { throw URLError(.badServerResponse) }
        self.requestInfo2 = requestInfo2
        
        guard let returnURL = value(.returnURL) else { throw URLError(.badServerResponse) }
        self.returnURL = returnURL
        
        guard let date = value(.date) else { throw URLError(.badServerResponse) }
        self.date = date
        
        guard let communicationID = value(.communicationID) else { throw URLError(.badServerResponse) }
        self.communicationID = communicationID
        
        guard let isCommunicationIDRequested = value(.isCommunicationIDRequested) else { throw URLError(.badServerResponse) }
        self.isCommunicationIDRequested = isCommunicationIDRequested == "Y" ? true : false
        
        guard let requestBaseEncryptionC = value(.requestBaseEncryptionC) else { throw URLError(.badServerResponse) }
        self.requestBaseEncryptionC = requestBaseEncryptionC
        
        guard let requestBaseEncryptionD = value(.requestBaseEncryptionD) else { throw URLError(.badServerResponse) }
        self.requestBaseEncryptionD = requestBaseEncryptionD
        
        guard let isSKTSMS = value(.isSKTSMS) else { throw URLError(.badServerResponse) }
        self.isSKTSMS = isSKTSMS == "Y" ? true : false
        
        guard let sktRequestTransitionID = value(.sktRequestTransitionID) else { throw URLError(.badServerResponse) }
        self.sktRequestTransitionID = sktRequestTransitionID
        
        guard let sktSMSAuthorizationID = value(.sktSMSAuthorizationID) else { throw URLError(.badServerResponse) }
        self.sktSMSAuthorizationID = sktSMSAuthorizationID
        
        guard let sktSMSBirthday = value(.sktSMSBirthday) else { throw URLError(.badServerResponse) }
        self.sktSMSBirthday = sktSMSBirthday
        
        guard let sktAuthorizationResult = value(.sktAuthorizationResult) else { throw URLError(.badServerResponse) }
        self.sktAuthorizationResult = sktAuthorizationResult
        
        guard let certificate1 = value(.certificate1) else { throw URLError(.badServerResponse) }
        self.certificate1 = certificate1
        
        guard let certificate2 = value(.certificate2) else { throw URLError(.badServerResponse) }
        self.certificate2 = certificate2
        
        guard let isChromeOniOSRequested = value(.isChromeOniOSRequested) else { throw URLError(.badServerResponse) }
        self.isChromeOniOSRequested = isChromeOniOSRequested == "Y" ? true : false
        
        guard let isCloseButtonHide = value(.isCloseButtonHide) else { throw URLError(.badServerResponse) }
        self.isCloseButtonHide = isCloseButtonHide
        
        guard let closeButtonLink = value(.closeButtonLink) else { throw URLError(.badServerResponse) }
        self.closeButtonLink = closeButtonLink
    }
}
