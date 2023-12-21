//
//  ReclaimButton.swift
//  Refuge
//
//  Created by Summerkirakira on 20/12/2023.
//

import Foundation
import SwiftUI

struct ReclaimButtonMenu: View {
    @Binding var pledgeIdList: [Int]
    @StateObject var mainPageViewModel: MainPageViewModel
    @Binding var currentItem: HangarItem
    @State var reclaimMode = 0
    @State var isShowReclaimSingleAlert = false
    @State var isShowReclaimAllAlert = false
    var body: some View {
        Menu {
            Button("回收一件") {
                isShowReclaimSingleAlert = true
            }

            Button("回收全部") {
//                debugPrint(mainPageViewModel.isShowErrorMessage)
                isShowReclaimAllAlert = true
            }
            
        } label: {
            makeTag(color: Color("ReclaimableGrey"), text: "可回收")
        }
        .alert(Text("融船警告"), isPresented: $isShowReclaimSingleAlert) {
            Button("取消", role: .cancel) {}
            Button("确认") {
                mainPageViewModel.loadingTitle = "融船中"
                mainPageViewModel.isShowLoading = true
                Task {
                    let result = await reclaimHangarItem(pledge_id: String(currentItem.id), password: mainPageViewModel.currentUser!.password)
                    if result == nil {
                        mainPageViewModel.isShowLoading = false
                        showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "未知错误", errorSubtitle: "请稍后重试")
                    }

                    if result!.success == 0 {
                        mainPageViewModel.isShowLoading = false
                        showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "融船失败", errorSubtitle: modifyReclaimerrorMessage(message: result!.msg))
                        return
                    } else {
                        mainPageViewModel.isShowLoading = false
                        
                        
                    }
                }
                
            }
        } message: {
            Text("即将对价值$\(currentItem.price / 100)(现价$\(currentItem.currentPrice / 100))的\n\(currentItem.name)\n进行单件融船操作，点击确定后该机库物品将永远消失且不可找回，预计融船结束后将会获得价值$\(currentItem.price / 100)的信用点。\n确定要继续吗？")
        }
        .simultaneousGesture(TapGesture().onEnded({
             // Stop propagation
        }))
        .alert(Text("融船警告"), isPresented: $isShowReclaimAllAlert) {
            
            Button("取消", role: .cancel) {}
            Button("确认") {
                mainPageViewModel.loadingTitle = "融船中"
                mainPageViewModel.isShowLoading = true
                Task {
                    for pledge_id in currentItem.idList {
                        let result = await reclaimHangarItem(pledge_id: String(pledge_id), password: mainPageViewModel.currentUser!.password)
                        if result == nil {
                            mainPageViewModel.isShowLoading = false
                            showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "未知错误", errorSubtitle: "请稍后重试")
                        }
                        
                        if result!.success == 0 {
                            mainPageViewModel.isShowLoading = false
                            showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "融船失败", errorSubtitle: modifyReclaimerrorMessage(message: result!.msg))
                            return
                        } else {
                            mainPageViewModel.isShowLoading = false
                        }
                    }
                }
                
            }
        } message: {
            Text("即将对\(currentItem.number)件价值$\(currentItem.price / 100 * currentItem.number)(现价$\(currentItem.currentPrice / 100 * currentItem.number))的\n\(currentItem.name)\n进行全部融船操作，点击确定后这些机库物品将永远消失且不可找回，预计融船结束后将会获得价值$\(currentItem.price / 100 * currentItem.number)的信用点。\n确定要继续吗？")
        }
    }
    
    func modifyReclaimerrorMessage(message: String) -> String {
        var modifiedMessage = ""
        if message.contains("A pledge can only be reclaimed more than 24h after it is acquired:") {
            modifiedMessage = message.replacingOccurrences(of: "A pledge can only be reclaimed more than 24h after it is acquired: ", with: "")
            let hourList = modifiedMessage.components(separatedBy: " hours ")
            if hourList.count == 2 {
                let minList = hourList[1].components(separatedBy: " minutes ")
                if minList.count == 2 {
                    modifiedMessage = "还有\(hourList[0])小时\(minList[0])分钟才可回收此物品哦"
                    return modifiedMessage
                } else {
                    modifiedMessage = "还有\(hourList[0])小时才可回收此物品哦"
                    return message
                }
            } else {
                return message
            }
        }
        return message
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



