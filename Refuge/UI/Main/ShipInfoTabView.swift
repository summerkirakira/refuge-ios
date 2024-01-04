//
//  ShipInfoTabView.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import SwiftUI
import NukeUI
import AlertToast

struct ShipInfoTabView: View {
    @StateObject private var mainPageViewModel = MainPageViewModel()
    @State var isFinishedLoading = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if (isFinishedLoading) {
                VStack(spacing: 0) {
                    TabView(selection: $mainPageViewModel.tabPosition) {
                        UpgradeShopView(mainPageViewModel: mainPageViewModel)
                            .tag(0)
                        HangarListView(mainPageViewModel: mainPageViewModel)
                            .tag(1)
                        UtilityPage(mainPageViewModel: mainPageViewModel)
                            .tag(2)
                        UserInfoMenu(mainPageViewModel: mainPageViewModel)
                            .tag(3)
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: mainPageViewModel.tabPosition) { newSelection in

                    }
                    .ignoresSafeArea()
                    .padding(.all, 0)
                    CustomTabBar(mainPageViewModel: mainPageViewModel)
                }
                .padding(.all, 0)
                .ignoresSafeArea()
                CustomTopBar(mainPageViewModel: mainPageViewModel)
                SideMenu(mainPageViewModel: mainPageViewModel)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: mainPageViewModel.needCheckLoginStatus) { newValue in
            if newValue == true {
                Task {
                    await checkRsiLogin()
                }
                mainPageViewModel.needCheckLoginStatus = false
            }
        }
        .onAppear {
            Task.init {
                do {
                    mainPageViewModel.loadingTitle = nil
                    mainPageViewModel.isShowLoading = true
                    userRepo.loadSync()
                    repository.loadSync()
                    bannerRepo.loadSync()
                    
                    upgradeRepo.loadSync()
                    
                    
                    mainPageViewModel.currentUser = userRepo.getCurrentUser()
                    mainPageViewModel.hangarItems = repository.items
                    mainPageViewModel.tabPosition = 2
                    mainPageViewModel.isShowLoading = false
                    isFinishedLoading = true
                    
                    if (mainPageViewModel.currentUser != nil) {
                        await checkRsiLogin()
                        
                        await upgradeRepo.refresh(needRefreshToken: true)
                        mainPageViewModel.upgradeList = await upgradeRepo.getFilteredUpgradeList()
                        sortUpgradeItem(mainPageViewModel: mainPageViewModel)
                    }
                    
                    await bannerRepo.refresh()
                    
                    mainPageViewModel.banners = bannerRepo.banners
                    
                    
                } catch {
                    mainPageViewModel.isShowLoading = false
                    isFinishedLoading = true
                    showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "加载数据库失败", errorSubtitle: "请重新登陆")
                }
            }
        }.toast(isPresenting: $mainPageViewModel.isShowErrorMessage) {
            AlertToast(displayMode: .hud, type: .regular, title: mainPageViewModel.errorMessageTitle, subTitle: mainPageViewModel.errorMessageSubTitle)
        }
        .toast(isPresenting: $mainPageViewModel.isShowLoading) {
            AlertToast(type: .loading, title: mainPageViewModel.loadingTitle)
        }
        .toast(isPresenting: $mainPageViewModel.isShowCompleteMessage) {
            AlertToast(type: .systemImage("checkmark.seal", Color("ColorPrimary")), title: mainPageViewModel.completeMessageTitle, subTitle: mainPageViewModel.completeMessageSubTitle)
        }
        .onChange(of: mainPageViewModel.needToRefreshHangar) { newValue in
            if newValue == true {
                mainPageViewModel.needToRefreshHangar = false
            }
            if mainPageViewModel.currentUser == nil {
                return
            }
            Task {
                mainPageViewModel.loadingTitle = "刷新机库中"
                mainPageViewModel.isShowLoading = true
                await repository.refreshHangar()
                mainPageViewModel.hangarItems = repository.items
                mainPageViewModel.isShowLoading = false
                let newUser = calUserHangarPrice(user: mainPageViewModel.currentUser!)
                userRepo.setCurrentUser(user: newUser)
                userRepo.saveSync(users: userRepo.users)
                mainPageViewModel.currentUser = newUser
            }
        }
        
        
    }
    
    func checkRsiLogin() async {
        let isLogin = await isLogin()
        if (!isLogin) {
            showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "账号登录失效", errorSubtitle: "正在尝试自动重新登陆")
            let userToken = await Rsilogin(email: mainPageViewModel.currentUser!.email, password: mainPageViewModel.currentUser!.password)
            if userToken != nil {
                showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "自动重新登陆失败", errorSubtitle: "需要两步验证，请重新登陆")
                return
            }
            let user = try? await parseNewUser(email: mainPageViewModel.currentUser!.email, password: mainPageViewModel.currentUser!.password, rsi_device: nil, rsi_token: nil)
            if user == nil {
                showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "自动重新登陆失败", errorSubtitle: "请重新登陆")
            } else {
                userRepo.setCurrentUser(user: user!)
                mainPageViewModel.currentUser = user!
                do {
                    try await userRepo.save()
                    showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "自动重新登陆成功", errorSubtitle: "账号信息已更新")
                } catch {
                    showErrorMessage(mainPageViewModel: mainPageViewModel, errorTitle: "自动重新登陆失败", errorSubtitle: "账号信息存储失败")
                }
                
                
            }
        }
    }
}

struct CustomTopBar: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State private var title: String = "我的机库"
    @State private var topBarColor: String = "ColorTopBarWhite"
    private let pipeline = ImagePipeline()
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Rectangle()
                        .foregroundColor(Color(topBarColor))
                        .frame(width: 10)
                        .frame(height: 2)
                        .cornerRadius(1)
                    Rectangle()
                        .foregroundColor(Color(topBarColor))
                        .frame(width: 8)
                        .frame(height: 2)
                        .cornerRadius(1)
                    Rectangle()
                        .foregroundColor(Color(topBarColor))
                        .frame(width: 10)
                        .frame(height: 2)
                        .cornerRadius(1)
                }
                Button(action: {
                    mainPageViewModel.isSideBarVisible.toggle()
                }) {
                    if mainPageViewModel.currentUser != nil {
                        makeUserCircleImage(url: URL(string: mainPageViewModel.currentUser!.profileImage))
                    } else {
                        Image("ic_user_bottom")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(topBarColor))
                    }
                    
                }
                Spacer()
//                FilterButtonMenu(mainViewModel: mainPageViewModel, topBarColorString: $topBarColor)
            }
            .padding(.top, 50)
            .padding(.horizontal, 20)
        }
        .frame(height: 85)
        .background(Color.clear)
        .ignoresSafeArea()
        .onChange(of: mainPageViewModel.tabPosition) { position in
            switch position {
            case 0:
                topBarColor = "ColorTopBarBlack"
            case 1:
                topBarColor = "ColorTopBarBlack"
            case 2:
                topBarColor = "ColorTopBarWhite"
            case 3:
                topBarColor = "ColorTopBarWhite"
            default:
                topBarColor = "ColorTopBarWhite"
            }
            
        }
    }
    
    func makeUserCircleImage(url: URL?) -> some View {
        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .cornerRadius(20)
            .frame(width: 27)
            .frame(height: 27)
    }
}

class MainPageViewModel: ObservableObject {
    @Published var tabPosition = 2
    @Published var isSideBarVisible = false
    @Published var currentUser: User? = nil
    @Published var hangarItems: [HangarItem] = []
    @Published var selectedItem: HangarItem? = nil
    @Published var isShowErrorMessage: Bool = false
    @Published var errorMessageTitle: String = "只是一个普通的错误"
    @Published var errorMessageSubTitle: String = "只是一个普通的错误"
    @Published var isShowLoading: Bool = false
    @Published var loadingTitle: String? = "少女祈祷中..."
    @Published var isShowCompleteMessage = false
    @Published var completeMessageTitle: String? = nil
    @Published var completeMessageSubTitle: String? = nil
    @Published var needToRefreshHangar: Bool = false
    @Published var hangarFilterString: String = ""
    
    @Published var upgradeList: [UpgradeListItem] = []
    
    
    @Published var needCheckLoginStatus = false
    @Published var banners: [Banner] = []
}

struct CustomTabBar: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State private var shopIconColor: String = "ColorUnselected"
    @State private var hangarIconColor: String = "ColorUnselected"
    @State private var mainIconColor: String = "ColorPrimary"
    @State private var meIconColor: String = "ColorUnselected"
    @State private var topBarColor: String = "ColorTopBarBlack"
    private let pipeline = ImagePipeline()
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
                    if (mainPageViewModel.currentUser != nil) {
                        makeUserCircleImage(url: URL(string: mainPageViewModel.currentUser!.profileImage))
                    } else {
                        Image("ic_user_bottom")
                            .resizable()
                            .foregroundColor(Color(meIconColor))
                            .frame(width: 30, height: 30)
                    }
                    
                }
            }
            .frame(height: 60)
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
        }
        .padding(.all, 0)
        .frame(height: 70)
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
            
            Task {
//                let token = try? await RsiApi.getDefaultRsiToken()
//                RsiApi.setToken(token: token!)
//                RsiApi.setDevice(device: "")
//                await RsiApi.setCsrfToken()
                
//                debugPrint(await RecaptchaV3().getRecaptchaToken())
            }
            
            
        }
        
    }
    func makeUserCircleImage(url: URL?) -> some View {
        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .cornerRadius(20)
            .frame(width: 40)
            .frame(height: 40)
    }
}

struct ShipInfoTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShipInfoTabView()
    }
}

