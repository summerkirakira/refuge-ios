import SwiftUI
import NukeUI

struct SideMenu: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    private let pipeline = ImagePipeline()
    
    
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.85
//    var bgColor: Color =
//          Color(.init(
//                  red: 52 / 255,
//                  green: 70 / 255,
//                  blue: 182 / 255,
//                  alpha: 1))
    var bgColor: Color = Color.white

    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.6))
            .opacity(mainPageViewModel.isSideBarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: mainPageViewModel.isSideBarVisible)
            .onTapGesture {
                mainPageViewModel.isSideBarVisible.toggle()
            }
            content
        }
        .edgesIgnoringSafeArea(.all)
    }

    var content: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                bgColor
                VStack {
                    NavigationView {
                        List {
                            if (mainPageViewModel.currentUser != nil) {
                                VStack {
                                    HStack {
                                        makeUserCircleImage(url: URL(string: mainPageViewModel.currentUser!.profileImage))
                                        VStack(alignment: .leading) {
                                            Text("信用点")
                                                .font(.system(size: 14))
                                                .bold()
                                            Spacer()
                                            Text("UEC")
                                                .font(.system(size: 14))
                                                .bold()
                                            Spacer()
                                            Text("REC")
                                                .font(.system(size: 14))
                                                .bold()
                                            Spacer()
                                            Text("机库价值")
                                                .font(.system(size: 14))
                                                .bold()
                                        }
                                        .padding(.leading, 20)
                                        VStack(alignment: .trailing) {
                                            Text("\(mainPageViewModel.currentUser!.usd / 100) USD")
                                                .font(.system(size: 14))
                                            Spacer()
                                            Text("\(mainPageViewModel.currentUser!.uec) UEC")
                                                .font(.system(size: 14))
                                            Spacer()
                                            Text("\(mainPageViewModel.currentUser!.rec) REC")
                                                .font(.system(size: 14))
                                            Spacer()
                                            Text("\(mainPageViewModel.currentUser!.hangarValue / 100) USD")
                                                .font(.system(size: 14))
                                        }
                                        Spacer()
                                    }.frame(height: 80)
                                }
                                .padding(.top, 60)
                                .padding(.leading, 20)
                                .padding(.bottom, 30)
                                .background(Color.gray.opacity(0.5))
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                                
                            }
                            
                            NavigationLink(destination: SettingsView(mainViewModel: mainPageViewModel)) {
                                HStack {
                                    Image(systemName: "gearshape")
                                    Text("设置")
                                }
                                
                            }
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(PlainListStyle())
                        .ignoresSafeArea()
                    }
                    .ignoresSafeArea()
                }
//                Button("少女祈祷中...点击关闭") {
//                    mainPageViewModel.isSideBarVisible.toggle()
//                }
//                .padding(.top, 300)
                
            }
            .frame(width: sideBarWidth)
            .offset(x: mainPageViewModel.isSideBarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: mainPageViewModel.isSideBarVisible)

            Spacer()
        }
    }
    
    func makeUserCircleImage(url: URL?) -> some View {
        Rectangle()
            .frame(width: 100)
            .frame(height: 100)
            .foregroundColor(Color.white)
            .cornerRadius(13)
            .overlay {
                ZStack(alignment: .center) {
                    LazyImage(source: url)
                        .pipeline(pipeline)
                        .cornerRadius(13)
                        .frame(width: 95)
                        .frame(height: 95)
//                    LoginMenu(mainViewModel: mainPageViewModel)
//                        .padding(.leading, 95)
//                        .padding(.top, 80)
                }
            }
    }
    
}
