//
//  SettingsView.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/10.
//

import SwiftUI
import NukeUI
import UIKit

@available(iOS 14.0, *)
@MainActor
struct SettingsView: View {
    @StateObject var mainViewModel: MainPageViewModel
    var body: some View {
        VStack {
            List {
                Toggle(isOn: $mainViewModel.isTranslationEnabled) {
                    VStack(alignment: .leading) {
                        Text("启用机库汉化")
                        Text("汉化机库内容(实验性)")
                            .font(.system(size: 12))
                            .opacity(0.5)
                        
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))
                Toggle(isOn: $mainViewModel.isReclaimEnabled) {
                    VStack(alignment: .leading) {
                        Text("禁止融船操作")
                        Text("打死我都不融船!")
                            .font(.system(size: 12))
                            .opacity(0.5)
                        
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))
                
                Toggle(isOn: $mainViewModel.isGiftBanned) {
                    VStack(alignment: .leading) {
                        Text("禁止礼物操作")
                        Text("打死我都不礼物!")
                            .font(.system(size: 12))
                            .opacity(0.5)
                        
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: .green))
                
                VStack(alignment: .leading) {
                    Text("UUID")
                    Text(getUuid())
                        .font(.system(size: 11))
                        .opacity(0.5)
                }
                .onTapGesture {
                    UIPasteboard.general.string = getUuid()
                    showCompleteMessage(mainPageViewModel: mainViewModel, completeTitle: "UUID已复制到剪切板")
                }
                VStack(alignment: .leading) {
                    Text("版本号")
                    Text(getAppVersion())
                        .font(.system(size: 12))
                        .opacity(0.5)
                }
                VStack(alignment: .leading) {
                    Text("开源协议")
                    Text("GNU General Public License v3.0")
                        .font(.system(size: 12))
                        .opacity(0.5)
                }
                VStack(alignment: .leading) {
                    Text("源代码")
                    Text("https://github.com/summerkirakira/refuge-ios")
                        .font(.system(size: 12))
                        .opacity(0.5)
                }
                .onTapGesture {
                    if let url = URL(string: "https://github.com/summerkirakira/refuge-ios") {
                                    UIApplication.shared.open(url)
                                }
                }
                VStack(alignment: .leading) {
                    Text("反馈与交流群")
                    Text("696608010")
                        .font(.system(size: 12))
                        .opacity(0.5)
                }
                .onTapGesture {
                    UIPasteboard.general.string = "696608010"
                    showCompleteMessage(mainPageViewModel: mainViewModel, completeTitle: "QQ群号已复制到剪切板")
                }

            }
        }
        .onChange(of: mainViewModel.isTranslationEnabled) { newValue in
            setIsTranslationEnabled(result: newValue)
        }
        .onChange(of: mainViewModel.isReclaimEnabled) { newValue in
            setIsReclaimEnabled(result: newValue)
        }
        .onChange(of: mainViewModel.isGiftBanned) { newValue in
            setIsGiftBanned(result: newValue)
        }
    }
    
    private let pipeline = ImagePipeline()
    
    func makeImage(url: URL) -> some View {
        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .frame(height: 100)
            .frame(width: 170)
            .cornerRadius(4)
    }
}
