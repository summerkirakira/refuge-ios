//
//  LoginMenu.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import Foundation
import SwiftUI

struct LoginMenu: View {
    @StateObject var mainViewModel: MainPageViewModel
    @State var isShowingLoginAlert = false
    @State var isMultiStepLoginAlert = false
    @State var username = ""
    @State var password = ""
    @State var multiStepCode = ""
    @State var rsiToken = ""
    var body: some View {
        Menu {
            ForEach(userRepo.getUsers(), id:\.handle) {user in
                Button(user.handle) {
                    userRepo.setCurrentUser(user: user)
                    mainViewModel.currentUser = user
                }
            }

            Button("登录新账号") {
                isShowingLoginAlert = true
            }
            
        } label: {
            if mainViewModel.currentUser == nil {
                Text("点击登录")
            } else {
                Image("exchange")
                    .scaleEffect(1.3)
                    .foregroundColor(Color.white)
                    .font(.title)
            }
            
        }
        .alert(Text("账号登录"), isPresented: $isShowingLoginAlert) {
            TextField("账号", text: $username)
                .padding()
            SecureField("密码", text: $password)
                .padding(.top, 0)
                .padding(.bottom, 40)
            Button("取消", role: .cancel) { }
            Button("确认") {
                Task {
                    let firstLoginStep = await Rsilogin(email: username, password: password)
                    if firstLoginStep != nil {
                        rsiToken = firstLoginStep!
                        isMultiStepLoginAlert = true
                    } else {
                        isMultiStepLoginAlert = false
                        let user = try? await parseNewUser(email: username, password: password, rsi_device: nil, rsi_token: nil)
                        if user != nil {
                            userRepo.setCurrentUser(user: user!)
                            mainViewModel.currentUser = user!
                            try await userRepo.save()
                            username = ""
                            password = ""
                        }
                    }
                    
                }
            }
        } message: {
            Text("登录你的RSI账号")
        }
        .alert(Text("需要两步验证"), isPresented: $isMultiStepLoginAlert) {
            TextField("验证码", text: $multiStepCode)
                .padding()
            Button("取消", role: .cancel) { }
            Button("确认") {
                Task {
                    let result = await RsiMultiLogin(code: multiStepCode)
                    if result == true {
                        let user = try? await parseNewUser(email: username, password: password, rsi_device: getDeviceId(), rsi_token: rsiToken)
                        debugPrint(user)
                        if user != nil {
                            userRepo.setCurrentUser(user: user!)
                            mainViewModel.currentUser = user!
                        }
                    }
                    username = ""
                    password = ""
                    multiStepCode = ""
                }
            }
        } message: {
            Text("请输入绑定邮箱中收到的验证码")
        }
    }
}
