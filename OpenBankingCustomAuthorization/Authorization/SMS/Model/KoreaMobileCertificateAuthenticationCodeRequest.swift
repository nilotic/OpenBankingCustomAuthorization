// 
//  KoreaMobileCertificateAuthenticationCodeRequest.swift
//
//  Created by Den Jo on 2021/08/21.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct KoreaMobileCertificateAuthenticationCodeRequest {
    let name: String
    let nationalID: String
    let gender: KoreaGender
    let phoneNumber: String
    let requestInfo: String
    let seedKey: String
    let returnURL: String
    let retry: String
    let encryptionVersion: String
    let isChromeOniOSRequested: Bool
    let isCloseButtonHide: String
    let closeButtonLink: String
}
    
extension KoreaMobileCertificateAuthenticationCodeRequest {
    
    init(name: String, nationalID: String, gender: KoreaGender, phoneNumber: String, response: KoreaMobileCertificateSMSResponse) {
        self.name        = name
        self.nationalID  = nationalID
        self.gender      = gender
        self.phoneNumber = phoneNumber
        
        requestInfo            = response.requestInfo
        seedKey                = response.seedKey
        returnURL              = response.returnURL
        retry                  = response.retry
        encryptionVersion      = response.encryptionVersion
        isChromeOniOSRequested = response.isChromeOniOSRequested
        isCloseButtonHide      = response.isCloseButtonHide
        closeButtonLink        = response.closeButtonLink
    }
}

extension KoreaMobileCertificateAuthenticationCodeRequest {
    
    // EUC-KR
    var encodedName: String {
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)
        
        guard let data = name.data(using: encoding) else { return "" }
            
        let string = data.map { byte -> String in
            if byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z") || byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z")
                || byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9")
                || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ".") || byte == UInt8(ascii: "-"), let scalar = UnicodeScalar(UInt32(byte)) {
                
                return String(Character(scalar))
                
            } else if byte == UInt8(ascii: " ") {
                return "+"
                
            } else {
                return String(format: "%%%02X", byte) }
            
        }.joined()
        
        return string
    }
}

extension KoreaMobileCertificateAuthenticationCodeRequest: Encodable {
    
    private enum Key: String, CodingKey {
        case name
        case birthday                 = "birth"
        case gender                   = "sex"
        case phoneNumber              = "phone"
        case requestInfo              = "reqInfo"
        case seedKey
        case returnURL
        case encryptionVersion        = "encVersion"
        case retry
        case isChromeOniOSRequested   = "reqCriOSYn"
        case isCloseButtonHide        = "closeBtnHide"
        case closeButtonLink          = "closeBtnLink"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(encodedName,       forKey: .name) }              catch { throw error }
        do { try container.encode(nationalID,          forKey: .birthday) }          catch { throw error }
        do { try container.encode(gender,            forKey: .gender) }            catch { throw error }
        do { try container.encode(phoneNumber,       forKey: .phoneNumber) }       catch { throw error }
        do { try container.encode(requestInfo,       forKey: .requestInfo) }       catch { throw error }
        do { try container.encode(seedKey,           forKey: .seedKey) }           catch { throw error }
        do { try container.encode(returnURL,         forKey: .returnURL) }         catch { throw error }
        do { try container.encode(encryptionVersion, forKey: .encryptionVersion) } catch { throw error }
        do { try container.encode(retry,             forKey: .retry) }             catch { throw error }
        do { try container.encode(isCloseButtonHide, forKey: .isCloseButtonHide) } catch { throw error }
        do { try container.encode(closeButtonLink,   forKey: .closeButtonLink) }   catch { throw error }
        
        do { try container.encode(isChromeOniOSRequested ? "Y" : "N", forKey: .isChromeOniOSRequested) } catch { throw error }
    }
}
