// 
//  OpenBankingARSRequest.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation

struct OpenBankingARSRequest {
    let accountNumber: String
    let accountNickname: String
    let accountType: AccountType
    let terms: [Bool]
    
    private let isAccountAuthorization = false
}

extension OpenBankingARSRequest: Encodable {

    private enum Key: String, CodingKey {
        case accountNumber          = "acntNum"
        case accountNickname        = "acntNkname"
        case isAccountAuthorization = "account_hold_auth_yn"
        case accountType            = "prtpOrgCode"
        case isTerms1Agreed         = "agreeTrms1"
        case isTerms2Agreed         = "agreeTrms2"
        case isTerms3Agreed         = "agreeTrms3"
        case isTerms4Agreed         = "agreeTrms4"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        
        do { try container.encode(accountNumber,   forKey: .accountNumber) }   catch { throw error }
        do { try container.encode(accountNickname, forKey: .accountNickname) } catch { throw error }
        
        // Terms
        do { try container.encode(terms[0] ? "on" : "off", forKey: .isTerms1Agreed) } catch { throw error }
        do { try container.encode(terms[1] ? "on" : "off", forKey: .isTerms2Agreed) } catch { throw error }
        do { try container.encode(terms[2] ? "on" : "off", forKey: .isTerms3Agreed) } catch { throw error }
        do { try container.encode(terms[3] ? "on" : "off", forKey: .isTerms4Agreed) } catch { throw error }
        
        
        // Account authorization
        do { try container.encode(isAccountAuthorization ? "Y" : "N", forKey: .isAccountAuthorization) } catch { throw error }
        
        
        // Account type
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 3
        
        guard let string = formatter.string(for: accountType.rawValue) else {
            throw EncodingError.invalidValue(container, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Failed to encode a accountType"))
        }
        
        do { try container.encode(string, forKey: .accountType) } catch { throw error }
    }
}
