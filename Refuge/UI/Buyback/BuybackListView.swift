//
//  BuybackListView.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/8.
//

import Foundation
import SwiftUI
import NukeUI

@available(iOS 14.0, *)
struct BuybackListView: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
//    @State var currentSelected: HangarItem? = nil
    @State var searchString: String = ""
    @State var isBottomSheetPresented = false
    private let pipeline = ImagePipeline()
    
    var body: some View {
        if (mainPageViewModel.currentUser != nil) {
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Spacer()
                        Text("我的回购")
                            .font(.system(size: 20))
                        Spacer()
                    }
                    HStack {
                        Spacer()
//                        FilterButtonMenu(mainViewModel: mainPageViewModel)
                    }
                }
                .padding(.top, 58)
                .padding(.bottom, 8)
                Divider()
                List{
                    SearchBar(searchText: $searchString)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.gray.opacity(0.01))
                    ForEach(mainPageViewModel.buybackItems.indices, id:\.self) {index in
                        BuybackListItemView(data: $mainPageViewModel.buybackItems[index], mainViewModel: mainPageViewModel)
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
                    mainPageViewModel.buybackItems = buybackRepo.items.filter { item in
                        isBuybackItemMatchedString(hangarItem: item, searchString: newValue)
                    }
                }
                .refreshable {
                    searchString = ""
                    await buybackRepo.refresh()
                    mainPageViewModel.buybackItems = buybackRepo.items
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
