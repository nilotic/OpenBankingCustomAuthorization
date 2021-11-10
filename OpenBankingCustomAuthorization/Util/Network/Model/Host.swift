
import Foundation

enum Host {
    case accounz(server: AccounzServer)
    case s3
    case openBanking(server: AccounzServer)
    case openBankingAPI(server: AccounzServer)
    case koreaMobileCertification
}

extension Host {
    
     var rawValue: String {
         switch self {
         case .accounz(let server):         return server.rawValue
         case .s3:                          return "https://s3.ap-northeast-2.amazonaws.com"
         case .openBanking(let server):     return OpenBankingServer(server: server).rawValue
         case .openBankingAPI(let server):  return OpenBankingAPIServer(server: server).rawValue
         case .koreaMobileCertification:    return "https://www.kmcert.com"
         }
     }
     
     var url: URL {
        URL(string: rawValue)!
     }
}

extension Host {
   
    init?(rawValue: String?) {
        guard let rawValue = rawValue else { return nil }
        
        switch rawValue {
    #if DEBUG
        case Host.accounz(server: .development).rawValue:           self = .accounz(server: .development)
        case Host.accounz(server: .stage).rawValue:                 self = .accounz(server: .stage)
        case Host.accounz(server: .production).rawValue:            self = .accounz(server: .production)
            
        case Host.openBanking(server: .development).rawValue:       self = .openBanking(server: .development)
        case Host.openBanking(server: .stage).rawValue:             self = .openBanking(server: .stage)
        case Host.openBanking(server: .production).rawValue:        self = .openBanking(server: .production)
            
        case Host.openBankingAPI(server: .development).rawValue:    self = .openBankingAPI(server: .development)
        case Host.openBankingAPI(server: .stage).rawValue:          self = .openBankingAPI(server: .stage)
        case Host.openBankingAPI(server: .production).rawValue:     self = .openBankingAPI(server: .production)

    #else
        case Host.accounz(server: .development).rawValue:           self = .accounz(server: .production)
        case Host.accounz(server: .stage).rawValue:                 self = .accounz(server: .production)
        case Host.accounz(server: .production).rawValue:            self = .accounz(server: .production)
            
        case Host.openBanking(server: .development).rawValue:       self = .openBanking(server: .production)
        case Host.openBanking(server: .stage).rawValue:             self = .openBanking(server: .production)
        case Host.openBanking(server: .production).rawValue:        self = .openBanking(server: .production)
            
        case Host.openBankingAPI(server: .development).rawValue:    self = .openBankingAPI(server: .production)
        case Host.openBankingAPI(server: .stage).rawValue:          self = .openBankingAPI(server: .production)
        case Host.openBankingAPI(server: .production).rawValue:     self = .openBankingAPI(server: .production)
            
    #endif
            
        case Host.s3.rawValue:                                      self = .s3
        case Host.koreaMobileCertification.rawValue:                self = .koreaMobileCertification
        default:                                                    return nil
        }
    }
}
