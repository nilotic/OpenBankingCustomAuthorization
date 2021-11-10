// 
//  AuthenticationAccountData.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI
import Combine

final class AuthenticationAccountData: ObservableObject {
    
    // MARK: - Value
    // MARK: Public
    @Published var accountType: AccountType = .none
    @Published var accountNumber   = ""
    @Published var accountNickname = ""
    
    @Published var isBankPolicyAgreed = false
    @Published var isFinancialPolicyAgreed = false
    @Published var is3rdPartyPolicyAgreed = false
    @Published var isProgressing = false
    @Published var isARSConfirmed: Bool? = nil
    
    @Published var isAllPolicesAgreed = false {
        didSet { terms = isAllPolicesAgreed ? Array(repeating: true, count: 4) : Array(repeating: false, count: 4) }
    }
    
    @Published var isResultAlertPresented = false
    var token: OpenBankingTokenResponse? = nil
    
    var terms = [false, false, false, false]
    
    let webViewRequestPublisher  = PassthroughSubject<(URLRequest, [HTTPCookie]), Never>()
    let webViewResponsePublisher = PassthroughSubject<Any, Error>()
    
    // MARK: Private
    private let cookie: HTTPCookie?
    private var subscriber: AnyCancellable?  = nil
    private var cancellable: AnyCancellable? = nil
    
    
    // MARK: - Initializer
    init(cookie: HTTPCookie?) {
        self.cookie = cookie
        
        setPublisher()
    }
    
    deinit {
        subscriber?.cancel()
    }
    
    
    // MARK: - Function
    // MARK: Public
    func requestCall() {
        guard let cookie = cookie else { return }
        
        var request = URLRequest(httpMethod: .post, url: .openBankingARS)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: OpenBankingServer(server: server).rawValue,                         field: .origin)
        request.set(value: ServiceURL.openBankingAuthorizationAccount.rawValue.absoluteString, field: .referer)
        
        let requestData = OpenBankingARSRequest(accountNumber: accountNumber, accountNickname: accountNickname, accountType: accountType, terms: terms)
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        webViewRequestPublisher.send((request, [cookie]))
    }
    
    func requestCallConfirmation() {
        guard let cookie = cookie else { return }
        
        var request = URLRequest(httpMethod: .post, url: .openBankingARSConfirmation)
        request.set(value: .urlEncoded, field: .contentType)
        
        request.set(value: OpenBankingServer(server: server).rawValue,                         field: .origin)
        request.set(value: ServiceURL.openBankingAuthorizationAccount.rawValue.absoluteString, field: .referer)
        
        let requestData = OpenBankingCallConfirmationRequest(email: "den@finddy.io")
        request.httpBody = urlComponets(from: request.url, data: requestData)?.query?.data(using: .utf8, allowLossyConversion: false)
        
        webViewRequestPublisher.send((request, [cookie]))
    }
    
    func requestToken(response: OpenBankingCallConfirmationResponse) {
        var request = URLRequest(httpMethod: .post, url: .openBankingToken)
        request.set(value: .urlEncoded,      field: .contentType)
        request.set(value: .applicationJSON, field: .accept)
        
        let requestData = OpenBankingTokenRequest(code: response.code)
        
        cancellable?.cancel()
        cancellable = NetworkManager.shared.request(urlRequest: request, requestData: requestData)
            .tryMap { response -> OpenBankingTokenResponse in
                guard let responseData = response.data else { throw URLError(.badServerResponse) }
                return try JSONDecoder().decode(OpenBankingTokenResponse.self, from: responseData)
            }
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .finished:             break
                case .failure(let error):   log(.error, error.localizedDescription)
                }
                
            } receiveValue: { [weak self] in
                self?.token = $0
                self?.isResultAlertPresented = true
            }
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
                case is OpenBankingARSResponse:                         self?.requestCall()
                case is OpenBankingCallResponse:                        self?.isARSConfirmed = false
                case let data as OpenBankingCallConfirmationResponse:   self?.requestToken(response: data)
                default:                                                break
                }
            }
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
