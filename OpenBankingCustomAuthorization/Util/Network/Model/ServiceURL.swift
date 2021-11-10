import Foundation

enum ServiceURL {
    case inquiry
    case relationRemittance
    case remittance
    case more
    case log
    case fileUpload
    
    // Sign Up
    case emailDomains
    case emailAuthenticationCode
    case emailAuthenticationCodeResend
    case emailAuthenticationCodeVerification
    case nicknameValidation
    case signUp
    
    // Log In
    case pincode
    case logIn
    
    // Open Banking
    case openBankingAuthorization
    case openBankingAuthorizationPolicies
    case openBankingAuthorizationConfirmations
    case openBankingAuthorizationAccount
    case openBankingARS
    case openBankingARSConfirmation
    case openBankingCallBack
    case openBankingToken
    
    // Korea Mobile Certificate
    case koreaMobileCertificate
    case koreaMobileCertificatePass
    case koreaMobileCompany
    case koreaMobileCertificateMethod
    case koreaMobileCertificateSMS
    case koreaMobileCertificateAuthenticationCode
    case koreaMobileCertificateAuthenticationCodeTimer
    case koreaMobileCertificateAuthenticationCodeConfirmation
}

extension ServiceURL {
    
    init?(url: URL?) {
        guard let url = url else { return nil }
        switch url {
        case ServiceURL.inquiry.rawValue:                                               self = .inquiry
        case ServiceURL.relationRemittance.rawValue:                                    self = .relationRemittance
        case ServiceURL.remittance.rawValue:                                            self = .remittance
        case ServiceURL.more.rawValue:                                                  self = .more
        case ServiceURL.log.rawValue:                                                   self = .log
        case ServiceURL.fileUpload.rawValue:                                            self = .fileUpload
        
        // Sign Up
        case ServiceURL.emailDomains.rawValue:                                          self = .emailDomains
        case ServiceURL.emailAuthenticationCode.rawValue:                               self = .emailAuthenticationCode
        case ServiceURL.emailAuthenticationCodeResend.rawValue:                         self = .emailAuthenticationCodeResend
        case ServiceURL.emailAuthenticationCodeVerification.rawValue:                   self = .emailAuthenticationCodeVerification
        case ServiceURL.nicknameValidation.rawValue:                                    self = .nicknameValidation
        case ServiceURL.signUp.rawValue:                                                self = .signUp
            
        // Log In
        case ServiceURL.pincode.rawValue:                                               self = .pincode
        case ServiceURL.logIn.rawValue:                                                 self = .logIn
        
        // Open Banking
        case ServiceURL.openBankingAuthorization.rawValue:                              self = .openBankingAuthorization
        case ServiceURL.openBankingAuthorizationPolicies.rawValue:                      self = .openBankingAuthorizationPolicies
        case ServiceURL.openBankingAuthorizationConfirmations.rawValue:                 self = .openBankingAuthorizationConfirmations
        case ServiceURL.openBankingAuthorizationAccount.rawValue:                       self = .openBankingAuthorizationAccount
        case ServiceURL.openBankingARS.rawValue:                                        self = .openBankingARS
        case ServiceURL.openBankingARSConfirmation.rawValue:                            self = .openBankingARSConfirmation
        case ServiceURL.openBankingCallBack.rawValue:                                   self = .openBankingCallBack
        case ServiceURL.openBankingToken.rawValue:                                      self = .openBankingToken
            
        // Korea Mobile Certificate
        case ServiceURL.koreaMobileCertificate.rawValue:                                self = .koreaMobileCertificate
        case ServiceURL.koreaMobileCertificatePass.rawValue:                            self = .koreaMobileCertificatePass
        case ServiceURL.koreaMobileCompany.rawValue:                                    self = .koreaMobileCompany
        case ServiceURL.koreaMobileCertificateMethod.rawValue:                          self = .koreaMobileCertificateMethod
        case ServiceURL.koreaMobileCertificateSMS.rawValue:                             self = .koreaMobileCertificateSMS
        case ServiceURL.koreaMobileCertificateAuthenticationCode.rawValue:              self = .koreaMobileCertificateAuthenticationCode
        case ServiceURL.koreaMobileCertificateAuthenticationCodeTimer.rawValue:         self = .koreaMobileCertificateAuthenticationCodeTimer
        case ServiceURL.koreaMobileCertificateAuthenticationCodeConfirmation.rawValue:  self = .koreaMobileCertificateAuthenticationCodeConfirmation
        default:                                                                        return nil
        }
    }
    
    init?(components: URLComponents) {
        guard let url = URL(string: "\(components.scheme ?? "")://\(components.host ?? "")\(components.path)"), let serviceURL = ServiceURL(url: url) else { return nil }
        self = serviceURL
    }
}

extension ServiceURL {
    
    var rawValue: URL {
        switch self {
        case .inquiry:                                                  return URL(string: "\(Host.accounz(server: server).rawValue)/api/v1/inquiry")!
        case .relationRemittance:                                       return URL(string: "\(Host.accounz(server: server).rawValue)/api/v1/relation-remittance")!
        case .remittance:                                               return URL(string: "\(Host.accounz(server: server).rawValue)/api/v1/remittance")!
        case .more:                                                     return URL(string: "\(Host.accounz(server: server).rawValue)/api/v1/more")!
        case .log:                                                      return URL(string: "\(Host.accounz(server: server).rawValue)/api/v1/log")!
        case .fileUpload:                                               return URL(string: "\(Host.accounz(server: server).rawValue)/api/v1/files/upload")!
            
        // Sign Up
        case .emailDomains:                                             return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/email/domains")!
        case .emailAuthenticationCode:                                  return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/email/authentication-code")!
        case .emailAuthenticationCodeResend:                            return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/email/authentication-code/resend")!
        case .emailAuthenticationCodeVerification:                      return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/email/authentication-code/verify")!
        case .nicknameValidation:                                       return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/nickname/validate")!
        case .signUp:                                                   return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/signup")!
        
        // Log In
        case .pincode:                                                  return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/pincode")!
        case .logIn:                                                    return URL(string: "\(Host.accounz(server: server).rawValue)/v1/user/login")!
            
        // Open Banking
        case .openBankingAuthorization:                                 return URL(string: "\(Host.openBankingAPI(server: server).rawValue)/oauth/2.0/authorize")!
        case .openBankingAuthorizationPolicies:                         return URL(string: "\(Host.openBanking(server: server).rawValue)/apt/mobileweb/authorizeNewGW")!
        case .openBankingAuthorizationConfirmations:                    return URL(string: "\(Host.openBanking(server: server).rawValue)/apt/mobileweb/authorize_set")!
        case .openBankingAuthorizationAccount:                          return URL(string: "\(Host.openBanking(server: server).rawValue)/apt/mobileweb/regiUser")!
        case .openBankingARS:                                           return URL(string: "\(Host.openBanking(server: server).rawValue)/apt/mobileweb/callArsRec")!
        case .openBankingARSConfirmation:                               return URL(string: "\(Host.openBanking(server: server).rawValue)/apt/mobileweb/newJoinChkAndRegiAcnt")!
        case .openBankingCallBack:                                      return URL(string: "\(Host.accounz(server: server).rawValue)/openbanking/callback")!
        case .openBankingToken:                                         return URL(string: "\(Host.openBankingAPI(server: server).rawValue)/oauth/2.0/token")!
            
        // Korea Mobile Certificate
        case .koreaMobileCertificate:                                   return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/web/kmcisReq.jsp")!
        case .koreaMobileCertificatePass:                               return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/pass_m/kmcisPass00.jsp")!
        case .koreaMobileCompany:                                       return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/pass_m/kmcisPass01.jsp")!
        case .koreaMobileCertificateMethod:                             return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/simpleCert_mobile_v2/kmcisApp01.jsp")!
        case .koreaMobileCertificateSMS:                                return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/mobile_v3/kmcisSms01.jsp")!
        case .koreaMobileCertificateAuthenticationCode:                 return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/mobile_v3/kmcisSms02.jsp")!
        case .koreaMobileCertificateAuthenticationCodeTimer:            return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/mobile_v3/kmcisSms03.jsp")!
        case .koreaMobileCertificateAuthenticationCodeConfirmation:     return URL(string: "\(Host.koreaMobileCertification.rawValue)/kmcis/mobile_v3/kmcisSms04.jsp")!
        }
    }
}
