//
//  HangarListView.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/3.
//

import SwiftUI
import NukeUI

enum UpgradeStep {
    case CHOOSE_TO_SHIP
    case CHOOSE_FROM_SHIP
}

@available(iOS 14.0, *)
struct UpgradeShopView: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State var searchString: String = ""
    @State var title = "请选择目标舰船"
    @State var step = UpgradeStep.CHOOSE_TO_SHIP
    @State var toSku: UpgradeListItem? = nil
    @State var fromSku: UpgradeListItem? = nil
    @State var isShowChooseToShipAlert = false
    @State var isShowFinalStepAlert = false
    @State var isShowInputNumberAlert = false
    @State private var inputNumber: String = ""
    @State var isShowBackBtn = false
    private let pipeline = ImagePipeline()
    
    
    
    var body: some View {
        if (mainPageViewModel.currentUser != nil) {
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Spacer()
                        Text(title)
                            .font(.system(size: 20))
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        if isShowBackBtn {
                            Button(action: {
                                step = UpgradeStep.CHOOSE_TO_SHIP
                                Task {
                                    mainPageViewModel.loadingTitle = "正在刷新可升级舰船"
                                    mainPageViewModel.isShowLoading = true
                                    mainPageViewModel.upgradeList = await upgradeRepo.getFilteredUpgradeList()
                                    sortUpgradeItem(mainPageViewModel: mainPageViewModel)
                                    mainPageViewModel.isShowLoading = false
                                }
                                
                            }) {
                                Image(systemName: "arrowshape.turn.up.backward.2")
                                    .resizable()
                                    .foregroundColor(Color("ColorTopBarBlack"))
                                    .frame(width: 30, height: 20)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
                .padding(.top, 58)
                .padding(.bottom, 8)
                Divider()
                List{
                    ForEach(mainPageViewModel.upgradeList.indices, id:\.self) {index in
                        UpgradeListItemView(data: $mainPageViewModel.upgradeList[index], mainViewModel: mainPageViewModel)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.gray.opacity(0.01))
                            .onTapGesture {
                                switch(step) {
                                case .CHOOSE_TO_SHIP:
                                    toSku = mainPageViewModel.upgradeList[index]
                                    isShowChooseToShipAlert = true
                                    
                                case .CHOOSE_FROM_SHIP:
                                    fromSku = mainPageViewModel.upgradeList[index]
                                    isShowInputNumberAlert = true
                                }
                                

                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 0)
                .padding(.bottom, 0)
//                .onChange(of: searchString) { newValue in
//                    mainPageViewModel.hangarItems = repository.items.filter { item in
//                        isHangarItemMatchedString(hangarItem: item, searchString: newValue)
//                    }
//                }
//                .refreshable {
//                    searchString = ""
//                    await repository.refreshHangar()
//                    mainPageViewModel.hangarItems = repository.items
//                    let newUser = calUserHangarPrice(user: mainPageViewModel.currentUser!)
//                    userRepo.setCurrentUser(user: newUser)
//                    userRepo.saveSync(users: userRepo.users)
//                    mainPageViewModel.currentUser = newUser
//                }
//                .sheet(isPresented: $isBottomSheetPresented) {
//                    ShipDetailBottomSheet(mainPageViewModel: mainPageViewModel, isBottomSheetPresented: $isBottomSheetPresented)
//                }
                .padding(.all, 0)
                Spacer()
            }
            .alert(Text("选择升级对象"), isPresented: $isShowChooseToShipAlert) {
                Button("取消", role: .cancel) {}
                Button("确认") {
                    step = UpgradeStep.CHOOSE_FROM_SHIP
                }
            } message: {
                if toSku != nil {
                    Text("确定要选择价值 $\(toSku!.price / 100) 的 \(toSku!.chineseName) 作为升级目标吗？你选择的版本是: \(toSku!.upgradeName)")
                }
            }
            .alert(Text("确定要购买升级吗"), isPresented: $isShowFinalStepAlert) {
                Button("取消", role: .cancel) {}
                Button("确认") {
                    
                }
            } message: {
                if toSku != nil && fromSku != nil && inputNumber != "" {
                    Text("确定要购买\(inputNumber)个 \(fromSku!.chineseName) 到 \(toSku!.chineseName)的升级包(价值$\((toSku!.price - fromSku!.price) / 100 * Int(inputNumber)!))吗？\n你选择的版本是: \(toSku!.upgradeName)")
                }
            }
            .alert(Text("确定要购买升级吗"), isPresented: $isShowInputNumberAlert) {
                VStack {
                    TextField("请输入购买数量", text: $inputNumber)
                        .keyboardType(.numberPad)
                    Button("取消", role: .cancel) {}
                    Button("确认") {
                        if Int(inputNumber) == nil {
                            showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "请输入一个正整数哦", errorSubtitle: "")
                            return
                        }
                        isShowFinalStepAlert = true
                    }
                }
            } message: {
                Text("请输入要购买升级的数量")
            }
            .background(Color.gray.opacity(0.04))
            .padding(.all, 0)
            .ignoresSafeArea()
            .onChange(of: step) { newValue in
                if newValue == UpgradeStep.CHOOSE_FROM_SHIP {
                    title = "请选择起始舰船"
                    isShowBackBtn = true
                    mainPageViewModel.upgradeList = mainPageViewModel.upgradeList.filter { item in
                        if item.chineseName == toSku!.chineseName {
                            return false
                        }
                        if item.price < toSku!.price {
                            return true
                        }
                        return false
                    }
                } else if (newValue == UpgradeStep.CHOOSE_TO_SHIP) {
                    isShowBackBtn = false
                }
                
            }
        } else {
            VStack {
                LoginMenu(mainViewModel: mainPageViewModel)
            }
        }
        
    }
    
//    func makeImage(url: URL?) -> some View {
//
//        LazyImage(source: url)
//            .animation(.default)
//            .pipeline(pipeline)
//            .cornerRadius(4)
//    }
    
}

func sortUpgradeItem(inc: Bool = true, mainPageViewModel: MainPageViewModel) {
    if inc {
        mainPageViewModel.upgradeList = mainPageViewModel.upgradeList.sorted {
            $0.price < $1.price
        }
    } else {
        mainPageViewModel.upgradeList = mainPageViewModel.upgradeList.sorted {
            $0.price > $1.price
        }
    }
}
