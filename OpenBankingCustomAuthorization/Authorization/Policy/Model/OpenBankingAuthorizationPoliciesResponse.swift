// 
//  OpenBankingAuthorizationPoliciesResponse.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import Foundation
import WebKit

struct OpenBankingAuthorizationPoliciesResponse {
    let certificate: String
    let url: URL
    let isAdded: Bool
    let cookie: HTTPCookie
}

extension OpenBankingAuthorizationPoliciesResponse {
    
    private enum Key: String, CodingKey {
        case certificate = "tr_cert"
        case url         = "tr_url"
        case isAdded     = "tr_add"
    }
    
    init(value: Any?, cookie: HTTPCookie) throws {
        guard let htmlString = value as? String,
              let regularExpression = try? NSRegularExpression(pattern: "<form name=\"reqKMCISForm\" id=\"reqKMCISForm\" method=\"post\">(?:\".*?\"|\'.*?\'|[^\'\"])*?</form>", options: [.dotMatchesLineSeparators]),
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
       
        guard let certificate = value(.certificate) else { throw URLError(.badServerResponse) }
        self.certificate = certificate
        
        guard let urlString = value(.url), let url = URL(string: urlString) else { throw URLError(.badServerResponse) }
        self.url = url
        
        guard let isAdded = value(.isAdded) else { throw URLError(.badServerResponse) }
        self.isAdded = isAdded == "Y" ? true : false
    }
}

#if DEBUG
extension OpenBankingAuthorizationPoliciesResponse {
    
    static var placeholder: OpenBankingAuthorizationPoliciesResponse {
        OpenBankingAuthorizationPoliciesResponse(certificate: "KMC000001-A29E72AA49AF09247240526E6CF48DA37D18164321E7BB5B5353D3663CC743AEB6E53750C6243937B5003F89FB2D041C1E4F9368F34649A63DE0F20BCC025065A6033548A5C17DEF0448FE7DBB7C8978FA5914BB8D7CFCAE6F090B4E0DF274E09AE8007123D174D85EB93AA6E43027596912D12A8B3C79E1FDEAD405988DDA95B84583ECFCE75847E89B2E82C5E8F2CEC16F220C985E6DA26BDA169B5AD02177D43FD33AAEC0BF1F3684EC2FC86E1944D005B2CA035C14EE03E234217BC043B1964C08BB9C80567F0E81BBE13E92934F23CCFE9C7E7CBCD4C218498ECF0E2049FF92B22659C6E76642D475A05ECC169AA5DE5D4CC9D74B049AEEB0B452B369EB",
                                                 url: URL(string: "https%3A%2F%2Ftwww.openbanking.or.kr%2Fapt%2Fmobileweb%2Fauthorize_rslt")!,
                                                 isAdded: false,
                                                 cookie: HTTPCookie())
    }
}
#endif
