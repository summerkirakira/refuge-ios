//
//  HangarListView.swift
//  Refuge
//
//  Created by Summerkirakira on 22/12/2022.
//

import SwiftUI
import NukeUI


struct SearchBar: View {
    @Binding var searchText: String
//    @Binding var isSearchBtnClicked: Bool

    var body: some View {
        HStack {
            TextField("搜索", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
            
//            Button(action: {
//                searchText = ""
//            }) {
//                Image(systemName: "magnifyingglass")
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(.gray)
//                    .padding(8)
//            }
//            .opacity(searchText.isEmpty ? 0 : 1)
//            .animation(.default)
        }
        .padding(.top, 5)
    }
}

@available(iOS 14.0, *)
struct HangarListView: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State var currentSelected: HangarItem? = nil
    @State var searchString: String = ""
    @State var isBottomSheetPresented = false
    private let pipeline = ImagePipeline()
    
    var body: some View {
        if (mainPageViewModel.currentUser != nil) {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Text("我的机库")
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(.top, 58)
                .padding(.bottom, 8)
                Divider()
                List{
                    SearchBar(searchText: $searchString)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.gray.opacity(0.01))
                    ForEach(mainPageViewModel.hangarItems.indices, id:\.self) {index in
                        HangarListItemView(data: $mainPageViewModel.hangarItems[index], mainViewModel: mainPageViewModel)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.gray.opacity(0.01))
                            .onTapGesture {
                                mainPageViewModel.selectedItem = mainPageViewModel.hangarItems[index]
                                isBottomSheetPresented = true
                                

                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, 0)
                .padding(.bottom, 0)
                .onChange(of: searchString) { newValue in
                    mainPageViewModel.hangarItems = repository.items.filter { item in
                        isHangarItemMatchedString(hangarItem: item, searchString: newValue)
                    }
                }
                .refreshable {
                    searchString = ""
                    await repository.refreshHangar()
                    mainPageViewModel.hangarItems = repository.items
                    let newUser = calUserHangarPrice(user: mainPageViewModel.currentUser!)
                    userRepo.setCurrentUser(user: newUser)
                    userRepo.saveSync(users: userRepo.users)
                    mainPageViewModel.currentUser = newUser
                }
                .sheet(isPresented: $isBottomSheetPresented) {
                    ShipDetailBottomSheet(mainPageViewModel: mainPageViewModel, isBottomSheetPresented: $isBottomSheetPresented)
                }
                .padding(.all, 0)
                Spacer()
            }
            .background(Color.gray.opacity(0.04))
            .padding(.all, 0)
            .ignoresSafeArea()
        } else {
            VStack {
                LoginMenu(mainViewModel: mainPageViewModel)
            }
        }
        
    }
    
    func makeImage(url: URL?) -> some View {

        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .cornerRadius(4)
    }
    
}
