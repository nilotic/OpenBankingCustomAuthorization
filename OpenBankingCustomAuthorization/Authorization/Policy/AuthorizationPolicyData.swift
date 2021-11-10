// 
//  AuthorizationPolicyData.swift
//
//  Created by Den Jo on 2021/08/12.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine

final class AuthorizationPolicyData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var isPrivacyPolicyAgreed = false
    @Published var is3rdPartyPolicyAgreed = false
    @Published var isProgressing = false
    
    @Published var isAllPolicesAgreed = false {
        didSet { terms = isAllPolicesAgreed ? Array(repeating: true, count: 3) : Array(repeating: false, count: 3) }
    }
    
    var terms  = [false, false, false]

    var response: OpenBankingAuthorizationPoliciesResponse? = nil
    var cookie: HTTPCookie? = nil
    
    let webViewRequestPublisher  = PassthroughSubject<(URLRequest, [HTTPCookie]), Never>()
    let webViewResponsePublisher = PassthroughSubject<Any, Error>()
    
    var privacyPolicy: String {
        """
        은행의 금융서비스를 표준화된 형태로 제공하는“오픈뱅킹 서비스”이용을 위한 고객의 개인정보 수집·이용에 대한 동의이며, 수집 및 이용하는 개인정보는 아래와 같습니다.
        ※ 오픈뱅킹 서비스는 은행권역 공동의 서비스로 금융결제원에서 관련 정보를 전달받아 운영하고 있습니다.

        1. 오픈뱅킹 서비스 이용(휴대폰 본인인증 계좌등록)
        - 수집 정보(필수항목) : 성명*, 생년월일*, 성별*, 내/외국인 구분*, 통신사명*, 휴대폰번호*, 연계정보(CI)값*, 중복가입확인정보(DI)값*, 은행코드**, 계좌번호**, 이메일주소***
        - 보유 기간 : 전자금융거래법 제22조에 따라 이용해지 후 5년까지

        * 본인확인기관(KMC)이 SMS 인증값 검증 및 유효성 확인 후 오픈뱅킹 센터에 제공
        ** 고객으로부터 직접 수집하며 금융실명법 제4조 제1항 제5호에 근거하여 처리
        *** 고객으로부터 직접 수집


        2. 오픈뱅킹 서비스 이용(공인인증서 본인확인 계좌등록)
        - 수집 정보(필수항목) : 성명*, 생년월일*, 성별*, 내외국인정보*, 연계정보(CI)값*, 중복가입확인정보(DI)값*, 은행코드**, 계좌번호**, 이메일주소***
        - 보유 기간 : 전자금융거래법 제22조에 따라 이용해지 후 5년까지

        * 본인확인기관(금융결제원)이 인증서 전자서명 검증 및 유효성 확인 후 오픈뱅킹 센터에 제공
        ** 고객으로부터 직접수집하며 금융실명법 제4조 제1항 제5호에 근거하여 처리
        *** 고객으로부터 직접 수집


        3. 민원 관리 목적
        - 수집 정보(필수항목) : 휴대폰번호, 이메일주소
        - 보유 기간 : 민원처리 완료 후 6개월까지

        고객은 개인정보 수집 및 이용을 거부할 권리가 있으며, 거부 시 이용에 제약을 받으실 수 있습니다.
        """
    }
    
    var thirdPartyInformationPolicy: String {
        """
        오픈뱅킹 서비스 고객 본인확인 및 이용을 위하여 제3자에게 고객 정보를 제공하는 것에 대한 동의이며, 제3자 정보제공 내역은 아래와 같습니다.
        1. 본인확인 목적
        - 제공받는자 : 이동통신사(SKT, KT, LGU+ 등), ㈜한국모바일인증, ㈜씽크에이티
        - 제공 정보 : 성명, 생년월일, 성별, 내/외국인 구분, 휴대폰번호
        - 보유 기간 : 서비스 제공일로부터 1개월(이동통신사), 서비스 제공일로부터 200일(㈜한국모바일인증), 서비스 제공일로부터 3년까지(㈜씽크에이티)
        
        2. 출금동의 확인 목적
        - 제공받는자 : 쿠콘
        - 제공 정보 : 성명, 생년월일, 성별, 내/외국인 구분, 계좌번호
        - 보유 기간 : 이용 해지시까지(다만, 1년이상 미이용시 1년 경과 시점까지)
        
        3. 이용기관의 고객 확인 목적
        - 제공받는자 : 이용기관
        - 제공 정보 : 성명, 생년월일*, 성별*, 휴대폰번호, 이메일주소, 연계정보(CI)값, 계좌번호**
        - 보유 기간 : 이용 해지시까지(다만, 1년이상 미이용시 1년 경과 시점까지)
        
        * 이용기관 상황에 따라 선별적으로 제공
        ** 금융실명법 제4조 제1항 제5호에 의거 소액해외송금업자로 등록한 이용기관에 한하여 제공
        
        고객은 제3자에게 정보를 제공하는 것을 거부할 권리가 있으며, 거부 시 이용에 제약을 받으실 수 있습니다.
        """
    }
    
    // MARK: Private
    private var task: Task<(), Never>? = nil
    private var subscriber: AnyCancellable? = nil
    
    
    // MARK: - Initializer
    init() {
        setPublisher()
    }
    
    deinit {
        subscriber?.cancel()
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        var request = URLRequest(httpMethod: .get, url: .openBankingAuthorization)
        let requestData = OpenBankingInitializeAuthorizationRequest(state: "12345678901234567890123456789013", isAccountAuthorization: false,
                                                                    scopes: [.logIn, .inquiry, .transfer], userAuthorizationType: .first, authorizationType: .mobile)
        
        request.url = urlComponets(from: request.url, data: requestData)?.url
      
        DispatchQueue.main.async { self.webViewRequestPublisher.send((request, [])) }
    }
    
    // MARK: Private
    private func setPublisher() {
        subscriber = webViewResponsePublisher
            .sink {
                switch $0 {
                case .finished:             break
                case .failure(let error):   log(.error, error.localizedDescription)
                }
                
            } receiveValue: { [weak self] in
                switch $0 {
                case let data as OpenBankingInitializeAuthorizationResponse:    self?.requestAuthorizationPolicies(response: data)
                case let data as OpenBankingAuthorizationPoliciesResponse:      self?.response = data
                default:                                                        break
                }
            }
    }
    
    private func requestAuthorizationPolicies(response: OpenBankingInitializeAuthorizationResponse){
        var request = URLRequest(httpMethod: .post, url: .openBankingAuthorizationConfirmations)
        request.set(value: .urlEncoded,      field: .contentType)
        request.set(value: .applicationJSON, field: .accept)
        
        request.set(value: Host.openBanking(server: server).rawValue, field: .origin)
        request.set(value: response.referer.absoluteString,           field: .referer)
        
        let requestData = OpenBankingAuthorizationPoliciesRequest(redirectURL: response.redirectURL)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        self.cookie = response.cookie
        
        DispatchQueue.main.async { self.webViewRequestPublisher.send((request, [response.cookie])) }
    }
    
    private func urlComponets<T: Encodable>(from url: URL?, data: T) -> URLComponents? {
        guard let string = url?.absoluteString, var urlComponent = URLComponents(string: string) else { return nil }
        
        do {
            guard var jsonData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(data), options: .mutableContainers) as? [String: Any] else { return nil }
            
            // Remove null container
            for key in jsonData.keys.filter({ jsonData[$0] is NSNull }) { jsonData.removeValue(forKey: key) }
            
            var queryItems = [URLQueryItem]()
            for (key, value) in jsonData {
                switch value {
                case let list as [Any]:     list.forEach { queryItems.append(URLQueryItem(name: key, value: "\($0)")) }
                default:                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
            }
            
            urlComponent.queryItems = queryItems.isEmpty ? nil : queryItems
            return urlComponent
            
        } catch {
            return nil
        }
    }
}
