// 
//  SMSAuthenticationData.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine

final class SMSAuthenticationData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var koreaMobileCompany: KoreaMobileCarrier = .none
    @Published var name                  = ""
    @Published var nationalID            = ""
    @Published var phoneNumber           = ""
    @Published var authenticationCode    = ""
    @Published var formatedRemainingTime = ""
    @Published var isAccountViewActive   = false
    
    @Published var genderString = "" {
        didSet { gender = KoreaGender(string: genderString) }
    }
    
    let authorizationPoliciesResponse: OpenBankingAuthorizationPoliciesResponse?
    let terms: [Bool]
    let openBankingCookie: HTTPCookie?
    var koreaMobileCertificateCookie: HTTPCookie?
    
    var timer: Timer? = nil
    
    let webViewRequestPublisher  = PassthroughSubject<(URLRequest, [HTTPCookie]), Never>()
    let webViewResponsePublisher = PassthroughSubject<Any, Error>()
    
    // MARK: Private
    private var subscriber: AnyCancellable? = nil
    
    private var gender: KoreaGender         = .none
    private var remainingTime: TimeInterval = 180
    
    private var koreaMobileCertificateResponse: KoreaMobileCertificateResponse? = nil
    private var koreaMobileCertificateAuthenticationCodeResponse: KoreaMobileCertificateAuthenticationCodeResponse? = nil
    
    
    // MARK: - Initializer
    init(response: OpenBankingAuthorizationPoliciesResponse?, terms: [Bool], cookie: HTTPCookie?) {
        authorizationPoliciesResponse = response
        self.terms = terms
        self.openBankingCookie = cookie
        
        setPublisher()
    }
    
    deinit {
        subscriber?.cancel()
    }
    
    
    // MARK: - Function
    // MARK: Public
    func request() {
        guard let response = authorizationPoliciesResponse else { return }
        var request = URLRequest(httpMethod: .post, url: .koreaMobileCertificate)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: OpenBankingServer(server: server).rawValue, field: .origin)
        request.set(value: response.url.absoluteString,                field: .referer)
        
        let requestData = KoreaMobileCertificateRequest(certificate: response.certificate, url: response.url, isAdded: response.isAdded, terms: terms)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        webViewRequestPublisher.send((request, []))
    }
    
    func requestAuthenticationCode() {
        guard let response = koreaMobileCertificateResponse else { return }
        var request = URLRequest(httpMethod: .post, url: .koreaMobileCompany)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: Host.koreaMobileCertification.rawValue,                        field: .origin)
        request.set(value: ServiceURL.koreaMobileCertificatePass.rawValue.absoluteString, field: .referer)
        
        let requestData = KoreaMobileCompanyRequest(koreaMobileCompany: koreaMobileCompany, response: response)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        webViewRequestPublisher.send((request, [response.cookie]))
    }
    
    func requestAuthenticationCodeConfirm() {
        guard let response = koreaMobileCertificateAuthenticationCodeResponse, let openBankingCookie = openBankingCookie else { return }
        
        var request = URLRequest(httpMethod: .post, url: .koreaMobileCertificateAuthenticationCodeConfirmation)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: Host.koreaMobileCertification.rawValue,                       field: .origin)
        request.set(value: ServiceURL.koreaMobileCertificateSMS.rawValue.absoluteString, field: .referer)
        
        let requestData = KoreaMobileCertificateAuthenticationCodeConfirmationRequest(authenticationCode: authenticationCode, remainingTime: remainingTime, response: response)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        webViewRequestPublisher.send((request, [response.cookie, openBankingCookie]))
    }
    
    func startTimer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
 
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingTime -= 1
            self.formatedRemainingTime = formatter.string(from: self.remainingTime) ?? ""
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
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
                case let data as KoreaMobileCertificateResponse:                                self?.koreaMobileCertificateResponse = data
                case let data as KoreaMobileCompanyResponse:                                    self?.requestKoreaMobileCertificateSMS(response: data)
                case let data as KoreaMobileCertificateSMSResponse:                             self?.requestSMSAuthenticationCode(response: data)
                case let data as KoreaMobileCertificateAuthenticationCodeResponse:              self?.koreaMobileCertificateAuthenticationCodeResponse = data
                case let data as KoreaMobileCertificateAuthenticationCodeConfirmationResponse:  self?.handle(response: data)
                default:                                                                        break
                }
            }
    }
    
    private func requestKoreaMobileCertificateSMS(response: KoreaMobileCompanyResponse) {
        var request = URLRequest(httpMethod: .post, url: .koreaMobileCertificateSMS)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: Host.koreaMobileCertification.rawValue,                          field: .origin)
        request.set(value: ServiceURL.koreaMobileCertificateMethod.rawValue.absoluteString, field: .referer)
        
        let requestData = KoreaMobileCertificateSMSRequest(response: response)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        webViewRequestPublisher.send((request, [response.cookie]))
    }
    
    private func requestSMSAuthenticationCode(response: KoreaMobileCertificateSMSResponse) {
        var request = URLRequest(httpMethod: .post, url: .koreaMobileCertificateAuthenticationCode)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: Host.koreaMobileCertification.rawValue,                       field: .origin)
        request.set(value: ServiceURL.koreaMobileCertificateSMS.rawValue.absoluteString, field: .referer)
        
        let requestData = KoreaMobileCertificateAuthenticationCodeRequest(name: name, nationalID: nationalID, gender: gender, phoneNumber: phoneNumber, response: response)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        koreaMobileCertificateCookie = response.cookie
        
        webViewRequestPublisher.send((request, [response.cookie]))
    }
    
    private func handle(response: KoreaMobileCertificateAuthenticationCodeConfirmationResponse) {
        koreaMobileCertificateCookie = response.cookie
        isAccountViewActive = true
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
