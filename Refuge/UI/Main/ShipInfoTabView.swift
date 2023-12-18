//
//  ShipInfoTabView.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import SwiftUI

struct ShipInfoTabView: View {
    @StateObject private var mainPageViewModel = MainPageViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomTopBar(mainPageViewModel: mainPageViewModel)
                TabView(selection: $mainPageViewModel.tabPosition) {
                    Text("First tab")
                        .tag(0)
                    HangarListView()
                        .tag(1)
                    Text("First tab")
                        .tag(2)
                    Text("First tab")
                        .tag(3)
                    
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: mainPageViewModel.tabPosition) { newSelection in

                }
                .ignoresSafeArea()
                .padding(.all, 0)
                CustomTabBar(mainPageViewModel: mainPageViewModel)
            }
            .ignoresSafeArea()
            SideMenu(mainPageViewModel: mainPageViewModel)
        }
    }
}

struct CustomTopBar: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State private var title: String = "我的机库"
    var body: some View {
        VStack {
            HStack {
//                Button(action: {
//                    mainPageViewModel.isSideBarVisible.toggle()
//                }) {
//                    Image("ic_user_bottom")
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                        .padding(.leading, 10)
//                        .foregroundColor(Color("ColorUnselected"))
//                }
                Spacer()
                Text(title)
                    .font(.system(size: 20))
                Spacer()
            }.padding(.top, 50)
        }
        .frame(height: 85)
        .background(Color.white)
        .ignoresSafeArea()
        .onChange(of: mainPageViewModel.tabPosition) { position in
            switch position {
            case 0:
                title = "商店"
            case 1:
                title = "我的机库"
            case 2:
                title = ""
            case 3:
                title = ""
            default:
                title = ""
            }
        }
    }
}

class MainPageViewModel: ObservableObject {
    @Published var tabPosition = 1
    @Published var isSideBarVisible = false
}

struct CustomTabBar: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State private var shopIconColor: String = "ColorUnselected"
    @State private var hangarIconColor: String = "ColorPrimary"
    @State private var mainIconColor: String = "ColorUnselected"
    @State private var meIconColor: String = "ColorUnselected"
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    mainPageViewModel.tabPosition = 0
                }) {
                    Image("ic_shop_bottom")
                        .resizable()
                        .foregroundColor(Color(shopIconColor))
                        .frame(width: 35, height: 35)
                }
                
                Spacer()
                
                Button(action: {
                    mainPageViewModel.tabPosition = 1
                }) {
                    Image("ic_hangar_bottom")
                        .resizable()
                        .foregroundColor(Color(hangarIconColor))
                        .frame(width: 35, height: 35)
                }
                
                Spacer()
                
                Button(action: {
                    mainPageViewModel.tabPosition = 2
                }) {
                    Image("ic_main_bottom")
                        .resizable()
                        .foregroundColor(Color(mainIconColor))
                        .frame(width: 35, height: 35)
                }
                
                Spacer()
                
                Button(action: {
                    mainPageViewModel.tabPosition = 3
                }) {
                    Image("ic_user_bottom")
                        .resizable()
                        .foregroundColor(Color(meIconColor))
                        .frame(width: 30, height: 30)
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
        .padding(.all, 0)
        .background(Color.white)
        .frame(height: 60)
        .onChange(of: mainPageViewModel.tabPosition) { newValue in
            switch newValue {
            case 0:
                shopIconColor = "ColorPrimary"
                hangarIconColor = "ColorUnselected"
                mainIconColor = "ColorUnselected"
                meIconColor = "ColorUnselected"
            case 1:
                shopIconColor = "ColorUnselected"
                hangarIconColor = "ColorPrimary"
                mainIconColor = "ColorUnselected"
                meIconColor = "ColorUnselected"
            case 2:
                shopIconColor = "ColorUnselected"
                hangarIconColor = "ColorUnselected"
                mainIconColor = "ColorPrimary"
                meIconColor = "ColorUnselected"
            case 3:
                shopIconColor = "ColorUnselected"
                hangarIconColor = "ColorUnselected"
                mainIconColor = "ColorUnselected"
                meIconColor = "ColorPrimary"
            default:
                shopIconColor = "ColorUnselected"
                hangarIconColor = "ColorUnselected"
                mainIconColor = "ColorUnselected"
            }
        }
        
    }
}

struct ShipInfoTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShipInfoTabView()
    }
}

