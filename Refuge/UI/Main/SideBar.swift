import SwiftUI

struct SideMenu: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    var bgColor: Color =
          Color(.init(
                  red: 52 / 255,
                  green: 70 / 255,
                  blue: 182 / 255,
                  alpha: 1))

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
            }
            .frame(width: sideBarWidth)
            .offset(x: mainPageViewModel.isSideBarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: mainPageViewModel.isSideBarVisible)

            Spacer()
        }
    }
}
