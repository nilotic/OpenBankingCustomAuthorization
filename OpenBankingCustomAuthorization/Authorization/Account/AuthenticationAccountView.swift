// 
//  AuthenticationAccountView.swift
//
//  Created by Den Jo on 2021/08/24.
//  Copyright © finddy Inc. All rights reserved.
//

import SwiftUI

struct AuthenticationAccountView: View {
    
    // MARK: - Value
    // MARK: Private
    @ObservedObject private var data: AuthenticationAccountData
    
    
    // MARK: - Initializer
    init(cookie: HTTPCookie?) {
        data = AuthenticationAccountData(cookie: cookie)
    }
    
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            OpenBankingAccountWebView()
                .frame(width: 0, height: 0)
                .environmentObject(data)
            
            
            ScrollView{
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment:. leading, spacing: 10) {
                        Text("은행")
                        
                        Picker("", selection: $data.accountType) {
                            ForEach(AccountType.allCases) {
                                Text($0.description)
                                    .tag($0)
                            }
                        }
                        .padding(.horizontal)
                        .border(.gray, width: 1)
                        
                        
                        TextField("계좌번호", text: $data.accountNumber)
                            .padding()
                            .border(.gray, width: 1)
                    
                        
                        TextField("계좌별명 (20글자 이내)", text: $data.accountNickname)
                            .padding()
                            .border(.gray, width: 1)
                    }
                    .padding(.bottom, 30)
                    
                    HStack {
                        Image(systemName: data.isAllPolicesAgreed ? "checkmark.square.fill" : "square")
                            .foregroundColor(data.isAllPolicesAgreed ? .blue : .secondary)
                        
                        Text("전체 동의")
                    }
                    .onTapGesture {
                        let isAgreed = !(data.isBankPolicyAgreed && data.isFinancialPolicyAgreed && data.is3rdPartyPolicyAgreed)
                        data.isAllPolicesAgreed      = isAgreed
                        data.isBankPolicyAgreed      = isAgreed
                        data.isFinancialPolicyAgreed = isAgreed
                        data.is3rdPartyPolicyAgreed  = isAgreed
                    }
                    
                    HStack {
                        Image(systemName: data.isBankPolicyAgreed ? "checkmark.square.fill" : "square")
                            .foregroundColor(data.isBankPolicyAgreed ? .blue : .secondary)
                        
                        Text("출금서비스(은행) 약관 동의")
                    }
                    .onTapGesture {
                        data.isBankPolicyAgreed.toggle()
                    }
                    
                    HStack {
                        Image(systemName: data.isFinancialPolicyAgreed ? "checkmark.square.fill" : "square")
                            .foregroundColor(data.isFinancialPolicyAgreed ? .blue : .secondary)
                        
                        Text("금융정보조회 이용 동의")
                    }
                    .onTapGesture {
                        data.isFinancialPolicyAgreed.toggle()
                    }
                    
                    HStack {
                        Image(systemName: data.is3rdPartyPolicyAgreed ? "checkmark.square.fill" : "square")
                            .foregroundColor(data.is3rdPartyPolicyAgreed ? .blue : .secondary)
                        
                        Text("금융정보 제3자 제공 동의")
                    }
                    .onTapGesture {
                        data.is3rdPartyPolicyAgreed.toggle()
                    }
                    
                    
                    VStack(spacing: 10) {
                        Button {
                            data.requestCall()
                            
                        } label: {
                            Text("ARS 출금/조회 동의")
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(data.isAllPolicesAgreed ? Color.blue : Color.gray)
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                            
                        Button {
                            
                        } label: {
                            Text("취소")
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 30)
                    
                    
                    Divider()
                    
                    if let isARSConfirmed = data.isARSConfirmed {
                        if !isARSConfirmed {
                            Text("전화를 받으시고 주민등록상의 생년월일 6자리를 입력해주세요.\nARS 인증완료 후 결과 확인버튼을 눌러주세요.")
                        }
                        
                        Button {
                            data.requestCallConfirmation()
                            
                        } label: {
                            Text("ARS 동의완료")
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                    }
                    
                }
            }
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $data.isResultAlertPresented) {
            Alert(title: Text("Token Info"), message: Text(data.token.debugDescription), dismissButton: .default(Text("OK")))
        }
    }
}


#if DEBUG
struct AuthenticationAccountView_Previews: PreviewProvider {
    
    static var previews: some View {
        let view = AuthenticationAccountView(cookie: nil)
        
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
