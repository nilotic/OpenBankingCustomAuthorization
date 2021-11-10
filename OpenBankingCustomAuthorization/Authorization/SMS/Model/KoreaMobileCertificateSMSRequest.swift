// 
//  KoreaMobileCertificateSMSRequest.swift
//
//  Created by Den Jo on 2021/08/21.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCertificateSMSRequest {
    let requestInfo: String
    let seedKey: String
    let encryptionVersion: String
    let returnURL: String
    let isChromeOniOSRequested: Bool
    let isCloseButtonHide: String
    let closeButtonLink: String
    let retry: String
}

extension KoreaMobileCertificateSMSRequest {
    
    init(response: KoreaMobileCompanyResponse) {
        requestInfo            = response.requestInfo
        seedKey                = response.seedKey
        encryptionVersion      = response.encryptionVersion
        returnURL              = response.returnURL
        isChromeOniOSRequested = response.isChromeOniOSRequested
        isCloseButtonHide      = response.isCloseButtonHide
        closeButtonLink        = response.closeButtonLink
        retry                  = response.retry
    }
}

extension KoreaMobileCertificateSMSRequest: Encodable {

    private enum Key: String, CodingKey {
        case requestInfo            = "reqInfo"
        case seedKey
        case encryptionVersion      = "encVersion"
        case returnURL
        case retry
        case isChromeOniOSRequested = "reqCriOSYn"
        case isCloseButtonHide      = "closeBtnHide"
        case closeButtonLink        = "closeBtnLink"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(requestInfo,       forKey: .requestInfo) }       catch { throw error }
        do { try container.encode(seedKey,           forKey: .seedKey) }           catch { throw error }
        do { try container.encode(encryptionVersion, forKey: .encryptionVersion) } catch { throw error }
        do { try container.encode(returnURL,         forKey: .returnURL) }         catch { throw error }
        do { try container.encode(isCloseButtonHide, forKey: .isCloseButtonHide) } catch { throw error }
        do { try container.encode(closeButtonLink,   forKey: .closeButtonLink) }   catch { throw error }
        do { try container.encode(retry,             forKey: .retry) }             catch { throw error }
        
        do { try container.encode(isChromeOniOSRequested ? "Y" : "N", forKey: .isChromeOniOSRequested) } catch { throw error }
    }
}
