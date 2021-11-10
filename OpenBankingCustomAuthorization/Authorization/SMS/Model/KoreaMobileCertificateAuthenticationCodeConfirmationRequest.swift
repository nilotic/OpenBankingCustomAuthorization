// 
//  KoreaMobileCertificateAuthenticationCodeConfirmationRequest.swift
//
//  Created by Den Jo on 2021/08/23.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation
import Foundation

struct KoreaMobileCertificateAuthenticationCodeConfirmationRequest {
    let authenticationCode: String
    let remainingTime: TimeInterval
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
}
    
extension KoreaMobileCertificateAuthenticationCodeConfirmationRequest {
    
    init(authenticationCode: String, remainingTime: TimeInterval, response: KoreaMobileCertificateAuthenticationCodeResponse) {
        self.authenticationCode = authenticationCode
        self.remainingTime      = remainingTime
        
        requestInfo                = response.requestInfo
        requestInfo1               = response.requestInfo1
        requestInfo2               = response.requestInfo2
        returnURL                  = response.returnURL
        date                       = response.date
        communicationID            = response.communicationID
        isCommunicationIDRequested = response.isCommunicationIDRequested
        requestBaseEncryptionC     = response.requestBaseEncryptionC
        requestBaseEncryptionD     = response.requestBaseEncryptionD
        isSKTSMS                   = response.isSKTSMS
        sktRequestTransitionID     = response.sktRequestTransitionID
        sktSMSAuthorizationID      = response.sktSMSAuthorizationID
        sktSMSBirthday             = response.sktSMSBirthday
        sktAuthorizationResult     = response.sktAuthorizationResult
        certificate1               = response.certificate1
        certificate2               = response.certificate2
        isChromeOniOSRequested     = response.isChromeOniOSRequested
        isCloseButtonHide          = response.isCloseButtonHide
        closeButtonLink            = response.closeButtonLink
    }
}

extension KoreaMobileCertificateAuthenticationCodeConfirmationRequest: Encodable {
    
    private enum Key: String, CodingKey {
        case authenticationCode         = "otp"
        case inputTime
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(authenticationCode,     forKey: .authenticationCode) }     catch { throw error }
        do { try container.encode(requestInfo,            forKey: .requestInfo) }            catch { throw error }
        do { try container.encode(requestInfo1,           forKey: .requestInfo1) }           catch { throw error }
        do { try container.encode(requestInfo2,           forKey: .requestInfo2) }           catch { throw error }
        do { try container.encode(returnURL,              forKey: .returnURL) }              catch { throw error }
        do { try container.encode(date,                   forKey: .date) }                   catch { throw error }
        do { try container.encode(communicationID,        forKey: .communicationID) }        catch { throw error }
        do { try container.encode(requestBaseEncryptionC, forKey: .requestBaseEncryptionC) } catch { throw error }
        do { try container.encode(requestBaseEncryptionD, forKey: .requestBaseEncryptionD) } catch { throw error }
        do { try container.encode(sktRequestTransitionID, forKey: .sktRequestTransitionID) } catch { throw error }
        do { try container.encode(sktSMSAuthorizationID,  forKey: .sktSMSAuthorizationID) }  catch { throw error }
        do { try container.encode(sktSMSBirthday,         forKey: .sktSMSBirthday) }         catch { throw error }
        do { try container.encode(sktAuthorizationResult, forKey: .sktAuthorizationResult) } catch { throw error }
        do { try container.encode(certificate1,           forKey: .certificate1) }           catch { throw error }
        do { try container.encode(certificate2,           forKey: .certificate2) }           catch { throw error }
        do { try container.encode(isCloseButtonHide,      forKey: .isCloseButtonHide) }      catch { throw error }
        do { try container.encode(closeButtonLink,        forKey: .closeButtonLink) }        catch { throw error }
        
        do { try container.encode(isCommunicationIDRequested ? "Y" : "N", forKey: .isCommunicationIDRequested) } catch { throw error }
        do { try container.encode(isSKTSMS                   ? "Y" : "N", forKey: .isSKTSMS) }                   catch { throw error }
        do { try container.encode(isChromeOniOSRequested     ? "Y" : "N", forKey: .isChromeOniOSRequested) }     catch { throw error }
        
        
        // Remaining
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
 
        guard let remainingTime = formatter.string(from: remainingTime) else {
            throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to encode the remaing."))
        }
        
        let component = remainingTime.components(separatedBy: ":")
        guard let minutes = component.first, let seconds = component.last else {
            throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to encode the remaing."))
        }

        do { try container.encode("+\(minutes)%BA%D0+\(seconds)%C3%CA", forKey: .inputTime) } catch { throw error }
    }
}
