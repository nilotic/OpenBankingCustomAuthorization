// 
//  KoreaMobileCompanyRequest.swift
//
//  Created by Den Jo on 2021/08/20.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCompanyRequest {
    let koreaMobileCompany: KoreaMobileCarrier
    let requestInfo: String
    let seedKey: String
    let returnURL: String
    let encryptionVersion: String
    let isChromeOniOSRequested: Bool
    let isCloseButtonHide: String
    let closeButtonLink: String
    let retry: String
    let sktBoboRequestInfo: String
    let hpProtectRequestInfo: String
    let hpMyOTPSMSRequestInfo: String
    let hpMngMyOTPSMSRequestInfo: String
}

extension KoreaMobileCompanyRequest {
    
    init(koreaMobileCompany: KoreaMobileCarrier, response: KoreaMobileCertificateResponse) {
        self.koreaMobileCompany = koreaMobileCompany
        
        requestInfo              = response.requestInfo
        seedKey                  = response.seedKey
        returnURL                = response.returnURL
        encryptionVersion        = response.encryptionVersion
        isChromeOniOSRequested   = response.isChromeOniOSRequested
        isCloseButtonHide        = response.isCloseButtonHide
        closeButtonLink          = response.closeButtonLink
        retry                    = response.retry
        sktBoboRequestInfo       = response.sktBoboRequestInfo
        hpProtectRequestInfo     = response.hpProtectRequestInfo
        hpMyOTPSMSRequestInfo    = response.hpMyOTPSMSRequestInfo
        hpMngMyOTPSMSRequestInfo = response.hpMngMyOTPSMSRequestInfo
    }
}

extension KoreaMobileCompanyRequest: Encodable {

    private enum Key: String, CodingKey {
        case koreaMobileCompany       = "telecom"
        case requestInfo              = "reqInfo_pass"
        case seedKey                  = "seedKey_pass"
        case returnURL                = "returnURL_pass"
        case encryptionVersion        = "encVersion_pass"
        case retry                    = "retry_pass"
        case isChromeOniOSRequested   = "reqCriOSYn"
        case isCloseButtonHide        = "closeBtnHide"
        case closeButtonLink          = "closeBtnLink"
        case sktBoboRequestInfo       = "sktBohoReqInfo"
        case hpProtectRequestInfo     = "hpProtectReqInfo"
        case hpMyOTPSMSRequestInfo    = "hpMyOTPsmsReqInfo"
        case hpMngMyOTPSMSRequestInfo = "hpMngMyOTPsmsReqInfo"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(koreaMobileCompany,       forKey: .koreaMobileCompany) }       catch { throw error }
        do { try container.encode(requestInfo,              forKey: .requestInfo) }              catch { throw error }
        do { try container.encode(seedKey,                  forKey: .seedKey) }                  catch { throw error }
        do { try container.encode(returnURL,                forKey: .returnURL) }                catch { throw error }
        do { try container.encode(encryptionVersion,        forKey: .encryptionVersion) }        catch { throw error }
        do { try container.encode(isCloseButtonHide,        forKey: .isCloseButtonHide) }        catch { throw error }
        do { try container.encode(closeButtonLink,          forKey: .closeButtonLink) }          catch { throw error }
        do { try container.encode(retry,                    forKey: .retry) }                    catch { throw error }
        do { try container.encode(sktBoboRequestInfo,       forKey: .sktBoboRequestInfo) }       catch { throw error }
        do { try container.encode(hpProtectRequestInfo,     forKey: .hpProtectRequestInfo) }     catch { throw error }
        do { try container.encode(hpMyOTPSMSRequestInfo,    forKey: .hpMyOTPSMSRequestInfo) }    catch { throw error }
        do { try container.encode(hpMngMyOTPSMSRequestInfo, forKey: .hpMngMyOTPSMSRequestInfo) } catch { throw error }
        
        do { try container.encode(isChromeOniOSRequested ? "Y" : "N", forKey: .isChromeOniOSRequested) } catch { throw error }
    }
}
