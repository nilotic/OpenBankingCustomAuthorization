// 
//  SMSAuthenticationView.swift
//
//  Created by Den Jo on 2021/08/19.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI

struct SMSAuthenticationView: View {
    
    // MARK: - Value
    // MARK: Private
    @ObservedObject private var data: SMSAuthenticationData
    
    
    // MARK: - Initializer
    init(response: OpenBankingAuthorizationPoliciesResponse?, terms: [Bool], cookie: HTTPCookie?) {
        data = SMSAuthenticationData(response: response, terms: terms, cookie: cookie)
    }
        
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            NavigationLink(destination: AuthenticationAccountView(cookie: data.koreaMobileCertificateCookie), isActive: $data.isAccountViewActive) {
                EmptyView()
            }
            
            KoreaMobileCertificateWebView()
                .frame(width: 0, height: 0)
                .environmentObject(data)
        
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment:. leading, spacing: 10) {
                    Text("통신사 선택")
                    
                    Picker("", selection: $data.koreaMobileCompany) {
                        ForEach(KoreaMobileCarrier.allCases) {
                            Text($0.description)
                                .tag($0)
                        }
                    }
                    .padding(.horizontal)
                    .border(.gray, width: 1)
                }
                
                VStack(alignment:. leading, spacing: 10) {
                    Text("이름")
                    
                    TextField("홍길동", text: $data.name)
                        .padding()
                        .border(.gray, width: 1)
                }
                
                
                VStack(alignment:. leading, spacing: 10) {
                    Text("주민번호")
                    
                    HStack {
                        TextField("210101", text: $data.nationalID)
                            .padding()
                            .border(.gray, width: 1)
                    
                        Text("  -  ")
                        
                        TextField("0", text: $data.genderString)
                            .padding()
                            .border(.gray, width: 1)
                    }
                    .keyboardType(.numberPad)
                    .border(.gray, width: 1)
                }
                
                
                VStack(alignment:. leading, spacing: 10) {
                    Text("휴대폰 번호")
                        .padding(.top, 10)
                    
                    TextField("-없이 숫자만 입력", text: $data.phoneNumber)
                        .padding()
                        .border(.gray, width: 1)
                    
                    
                    Button {
                        data.startTimer()
                        data.requestAuthenticationCode()
                        
                    } label: {
                        Text("인증번호 요청")
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .padding()
                    }
                }
                
                if data.timer != nil {
                    VStack(alignment:. leading, spacing: 10) {
                        Text("인증번호")
                            .padding(.top, 10)
                        
                        HStack(spacing: 20) {
                            TextField("000000", text: $data.authenticationCode)
                                .frame(width: 100)
                                .padding()
                                .border(.gray, width: 1)
                            
                            
                            Text(data.formatedRemainingTime)
                                .font(.system(size: 20))
                        }
                    }
                }
                
                
                Button {
                    data.stopTimer()
                    data.requestAuthenticationCodeConfirm()
                    
                } label: {
                    Text("확인")
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .padding()
                }
            }
            .padding(.horizontal, 20)
        }
        .task {
            data.request()
        }
    }
}

#if DEBUG
struct SMSAuthorizationView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = SMSAuthenticationView(response: .placeholder, terms: [true, true, true], cookie: nil)
        
        Group {
            view
                .previewDevice("iPhone 8")
                .preferredColorScheme(.light)
            
            view
                .previewDevice("iPhone 11 Pro")
                .preferredColorScheme(.light)
        }
    }
}
#endif
