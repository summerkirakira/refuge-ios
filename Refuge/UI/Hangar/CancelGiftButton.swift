//
//  CancelGiftButton.swift
//  Refuge
//
//  Created by Summerkirakira on 2023/12/23.
//

import Foundation
import SwiftUI



struct CancelGiftButtonMenu: View {
    @StateObject var mainPageViewModel: MainPageViewModel
    @Binding var currentItem: HangarItem
    @State var isShowAlert = false
    var body: some View {
        makeTag(color: Color("GiftablePink"), text: "已礼物")
            .contentShape(Rectangle())
            .onTapGesture {
                isShowAlert = true
            }
        .simultaneousGesture(TapGesture().onEnded({
             // Stop propagation
        }))
        .alert(Text("确认要收回礼物吗"), isPresented: $isShowAlert) {
//            Text("确认要收回礼物: \(currentItem.name)吗？发送到目标邮箱的领取链接将即刻失效。")
            Button("取消", role: .cancel) { }
            Button("确认") {
                mainPageViewModel.isShowLoading = true
                Task {
                    let result = await cancelGiftHangarItem(pledge_id: String(currentItem.id))
                    
                    if result == nil {
                        showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "未知错误", errorSubtitle: "请稍后重试")
                    }

                    if result!.success == 0 {
                        showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "收回礼物失败", errorSubtitle: result!.msg)
                        return
                    } else {
                        mainPageViewModel.needToRefreshHangar = true
                        showCompleteMessage(mainPageViewModel: mainPageViewModel, completeTitle: "收回礼物成功", completeSubtitle: "正在刷新机库")
                    }
                    mainPageViewModel.isShowLoading = false
                }
            }
        }
    }
    
    func makeTag(color: Color, text: String) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(color, lineWidth: 1)
            .frame(height: 22)
            .frame(width: 40)
            .overlay(
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(color)
            )
            .padding(0)
    }
}
