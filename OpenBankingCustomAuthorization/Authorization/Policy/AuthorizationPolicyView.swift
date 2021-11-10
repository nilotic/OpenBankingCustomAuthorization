// 
//  AuthorizationView.swift
//
//  Created by Den Jo on 2021/08/12.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI

struct AuthorizationPolicyView: View {
    
    // MARK: - Value
    // MARK: Public
    @StateObject var data = AuthorizationPolicyData()
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            OpenBankingWebView()
                .frame(width: 0, height: 0)
                .environmentObject(data)
                
            switch data.isProgressing {
            case true:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.2, anchor: .center)

            case false:
                policyView
            }
        }
        .task {
            data.request()
        }
    }
    
    // MARK: Private
    private var policyView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("휴대폰 인증")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 20)
            
            
            HStack {
                Image(systemName: data.isPrivacyPolicyAgreed ? "checkmark.square.fill" : "square")
                    .foregroundColor(data.isPrivacyPolicyAgreed ? .blue : .secondary)
                
                Text("전체 동의")
            }
            .onTapGesture {
                let isAgreed = !(data.isPrivacyPolicyAgreed && data.is3rdPartyPolicyAgreed)
                data.isAllPolicesAgreed     = isAgreed
                data.isPrivacyPolicyAgreed  = isAgreed
                data.is3rdPartyPolicyAgreed = isAgreed
            }
            
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: data.isPrivacyPolicyAgreed ? "checkmark.square.fill" : "square")
                        .foregroundColor(data.isPrivacyPolicyAgreed ? .blue : .secondary)
                    
                    Text("서비스 이용 및 개인정보처리 동의")
                }
                .onTapGesture {
                    data.isPrivacyPolicyAgreed.toggle()
                    data.isAllPolicesAgreed = data.isPrivacyPolicyAgreed && data.is3rdPartyPolicyAgreed
                }
                
                TextEditor(text: .constant(data.privacyPolicy))
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .padding()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: data.is3rdPartyPolicyAgreed ? "checkmark.square.fill" : "square")
                        .foregroundColor(data.is3rdPartyPolicyAgreed ? .blue : .secondary)
                    
                    Text("개인정보 제3자 제공 동의")
                }
                .onTapGesture {
                    data.is3rdPartyPolicyAgreed.toggle()
                    data.isAllPolicesAgreed = data.isPrivacyPolicyAgreed && data.is3rdPartyPolicyAgreed
                }
                
                TextEditor(text: .constant(data.thirdPartyInformationPolicy))
                    .frame(height: 150)
                    .border(Color.gray, width: 1)
                    .padding()
            }
            
            NavigationLink(destination: SMSAuthenticationView(response: data.response, terms: data.terms, cookie: data.cookie)) {
                Text("본인 확인")
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(data.isPrivacyPolicyAgreed ? Color.blue : Color.gray)
                    .cornerRadius(20)
                    .padding()
            }
        }
        .padding()
    }
}

#if DEBUG
struct AuthorizationView_Previews: PreviewProvider {

    static var previews: some View {
        let view = AuthorizationPolicyView()
        
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
