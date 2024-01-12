//
//  ReclaimButton.swift
//  Refuge
//
//  Created by Summerkirakira on 20/12/2023.
//

import Foundation
import SwiftUI

struct GiftButtonMenu: View {
    @StateObject var mainPageViewModel: MainPageViewModel
    @Binding var currentItem: HangarItem
    @State var giftMode = 0
    @State var isShowGiftSingleAlert = false
    @State var isShowGiftAllAlert = false
    @State var isShowGiftTargetAlert = false
    @State var targetEmail: String = ""
    var body: some View {
        Menu {
            Button("礼物一件") {
                if (mainPageViewModel.isReclaimEnabled) {
                    showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "礼物操作已被禁止", errorSubtitle: "请前往设置开启哦")
                    return
                }
                isShowGiftTargetAlert = true
                giftMode = 1
            }

            Button("礼物全部") {
                if (mainPageViewModel.isReclaimEnabled) {
                    showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "礼物操作已被禁止", errorSubtitle: "请前往设置开启哦")
                    return
                }
                isShowGiftTargetAlert = true
                giftMode = 2
            }

        } label: {
            makeTag(color: Color("GiftablePink"), text: "可礼物")
        }
        .alert(Text("请输入要礼物目标"), isPresented: $isShowGiftTargetAlert) {
            TextField("邮箱地址", text: $targetEmail)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            Button("取消", role: .cancel) {
                giftMode = 0
            }
            Button("确认") {
                if targetEmail == "" {
                    showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "请输入正确的邮箱地址", errorSubtitle: "目标邮箱地址不可为空")
                    return
                }
                if (giftMode == 1) {
                    isShowGiftSingleAlert = true
                } else if (giftMode == 2) {
                    isShowGiftAllAlert = true
                }
            }
        }
        .alert(Text("礼物警告"), isPresented: $isShowGiftSingleAlert) {
            Button("取消", role: .cancel) {}
            Button("确认") {
                mainPageViewModel.loadingTitle = "礼物中"
                mainPageViewModel.isShowLoading = true
                Task {
                    let result = await giftHangarItem(pledge_id: String(currentItem.id), password: mainPageViewModel.currentUser!.password, email: targetEmail)
                    if result == nil {
                        mainPageViewModel.isShowLoading = false
                        showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "未知错误", errorSubtitle: "请稍后重试")
                    }

                    if result!.success == 0 {
                        mainPageViewModel.isShowLoading = false
                        showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "礼物失败", errorSubtitle: result!.msg)
                        return
                    } else {
                        mainPageViewModel.isShowLoading = false
                        mainPageViewModel.needToRefreshHangar = true
                        showCompleteMessage(mainPageViewModel: mainPageViewModel, completeTitle: "礼物成功", completeSubtitle: "")
                    }
                }

            }
        } message: {
            Text("即将对价值$\(currentItem.price / 100)(现价$\(currentItem.currentPrice / 100))的\n\(currentItem.name)\n进行礼物操作，\n礼物对象: \(targetEmail)\n点击确定后该机库物品将被发送到目标邮箱且对方确认接收后将无法找回\n确定要继续吗？")
        }
        .simultaneousGesture(TapGesture().onEnded({
             // Stop propagation
        }))
        .alert(Text("融船警告"), isPresented: $isShowGiftAllAlert) {

            Button("取消", role: .cancel) {}
            Button("确认") {
                mainPageViewModel.loadingTitle = "礼物中"
                mainPageViewModel.isShowLoading = true
                Task {
                    for pledge_id in currentItem.idList {
                        let result = await giftHangarItem(pledge_id: String(pledge_id), password: mainPageViewModel.currentUser!.password, email: targetEmail)
                        if result == nil {
                            mainPageViewModel.isShowLoading = false
                            showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "未知错误", errorSubtitle: "请稍后重试")
                        }

                        if result!.success == 0 {
                            mainPageViewModel.isShowLoading = false
                            showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "礼物失败", errorSubtitle:result!.msg)
                            return
                        } else {
                            mainPageViewModel.isShowLoading = false
                            mainPageViewModel.needToRefreshHangar = true
                            showCompleteMessage(mainPageViewModel: mainPageViewModel, completeTitle: "礼物成功", completeSubtitle: "")
                        }
                    }
                }

            }
        } message: {
            Text("即将对\(currentItem.number)件价值$\(currentItem.price / 100 * currentItem.number)(现价$\(currentItem.currentPrice / 100 * currentItem.number))的\n\(currentItem.name)\n进行全部礼物操作，\n礼物对象: \(targetEmail)\n点击确定后该机库物品将被发送到目标邮箱且对方确认接收后将无法找回\n确定要继续吗？")
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



