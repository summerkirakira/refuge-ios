//
//  UserInfoView.swift
//  Refuge
//
//  Created by Summerkirakira on 19/12/2023.
//

import SwiftUI
import NukeUI

struct UserInfoMenu: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    private let pipeline = ImagePipeline()
    var body: some View {
        if mainPageViewModel.currentUser != nil {
            List {
                    ZStack {
                        Rectangle()
                            .frame(height: 250)
                            .foregroundColor(Color("ColorPrimary"))
                        makeUserCircleImage(url: URL(string: mainPageViewModel.currentUser!.profileImage))
                            .padding(.top, 50)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                
                    VStack(alignment: .leading, spacing: 10) {
                        Text(mainPageViewModel.currentUser!.handle)
                            .font(.system(size: 30))
                            .padding(.top, 20)
                        Text(mainPageViewModel.currentUser!.name)
                            .font(.system(size: 22))
                        Divider()
                        VStack(spacing: 4) {
                            HStack {
                                Text("注册时间")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text(mainPageViewModel.currentUser!.registerTimeString)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("所属舰队")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                if (mainPageViewModel.currentUser!.organizationName != nil) {
                                    Text(mainPageViewModel.currentUser!.organizationName!)
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.black.opacity(0.6))
                                } else {
                                    Text("无")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.black.opacity(0.6))
                                }
                                
                            }
                            HStack {
                                Text("舰队等级")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                if (mainPageViewModel.currentUser!.organizationName != nil) {
                                    Text("Lv.\(mainPageViewModel.currentUser!.orgLevel) \(mainPageViewModel.currentUser!.orgRank!)")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.black.opacity(0.6))
                                } else {
                                    Text("无")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.black.opacity(0.6))
                                }
                                
                            }
                        }
                        
                        
                        Divider()
                        
                        VStack(spacing: 4) {
                            HStack {
                                Text("机库可融价值")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.hangarValue / 100) USD")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("机库当前价值")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.currentHangarValue / 100) USD")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("信用点")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.usd / 100) USD")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("UEC")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.uec) UEC")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("REC")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.rec) REC")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("消费额")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.totalSpent / 100) USD")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                        }
                        
                        Divider()
                        
                        VStack(spacing: 4) {
                            HStack {
                                Text("成功邀请数量")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.referralCount) 人")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("邀请数量(未购买游戏包)")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text("\(mainPageViewModel.currentUser!.referralProspectCount) 人")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                            HStack {
                                Text("邀请码")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                                Spacer()
                                Text(mainPageViewModel.currentUser!.referralCode)
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.black.opacity(0.6))
                            }
                        }
                        
                    }
                    .background(Color.white)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .padding(.horizontal, 20)
                }
                .background {
                    VStack {
                        Rectangle()
                            .frame(height: 700)
                            .foregroundColor(Color("ColorPrimary"))
                        Rectangle()
                            .frame(height: 1000)
                            .foregroundColor(Color.white)
                    }
                    
                }
                .refreshable {
                    do {
                        let user = try? await parseNewUser(email: mainPageViewModel.currentUser!.email, password: mainPageViewModel.currentUser!.password, rsi_device: RsiApi.getDefaultDevice(), rsi_token: mainPageViewModel.currentUser!.rsi_token)
                    } catch {
                        
                    }
                    
                }
                .listStyle(PlainListStyle())
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    func makeUserCircleImage(url: URL?) -> some View {
        Rectangle()
            .frame(width: 100)
            .frame(height: 100)
            .foregroundColor(Color.white)
            .cornerRadius(120)
            .overlay {
                ZStack(alignment: .center) {
                    LazyImage(source: url)
                        .pipeline(pipeline)
                        .cornerRadius(100)
                        .frame(width: 95)
                        .frame(height: 95)
                }
            }
        
            
    }

}
