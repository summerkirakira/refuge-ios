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

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
            
            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .opacity(searchText.isEmpty ? 0 : 1)
            .animation(.default)
        }
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
        VStack {
            List{
//                SearchBar(searchText: $searchString)
                ForEach(mainPageViewModel.hangarItems.indices, id:\.self) {index in
                    HangarListItemView(data: $mainPageViewModel.hangarItems[index])
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.gray.opacity(0.01))
                        .onTapGesture {
                            mainPageViewModel.selectedItem = mainPageViewModel.hangarItems[index]
                            
                            isBottomSheetPresented = true
                            Task {
//                                let token = await recaptchaV3.getRecaptchaToken()
//                                debugPrint(token)

                            }

                    }
                }
            }
            .listStyle(PlainListStyle())
            .padding(.all, 0)
            .refreshable {
                await repository.refreshHangar()
                mainPageViewModel.hangarItems = repository.items
            }
            .searchable(text: $searchString) {
                
            }
            .sheet(isPresented: $isBottomSheetPresented) {
                ScrollView {
                    VStack {
                        HStack {
                            makeImage(url: URL(string: mainPageViewModel.selectedItem!.image))
                                .frame(height: 130)
                                .frame(width: 130)
                            VStack(alignment: .leading) {
                                if mainPageViewModel.selectedItem!.chineseName != nil {
                                    Text(mainPageViewModel.selectedItem!.chineseName!)
                                        .bold()
                                        .lineLimit(2)
                                        .font(.system(size: 20))
                                        .padding(.all, 0)
                                }
                                Text(mainPageViewModel.selectedItem!.name)
                                    .font(.system(size: 14))
                                    .lineLimit(3)
                                    .padding(.all, 0)
                                    .padding(.top, 5)
                            }
                            Spacer()
                        }
                        if mainPageViewModel.selectedItem!.items.count > 0 {
                            Divider()
                                .padding(.top, 5)
                            HStack() {
                                Text("内容")
                                    .bold()
                                    .font(.system(size: 24))
                                Spacer()
                                Text("详情>")
                                    .opacity(0.7)
                            }
                        }
                        
                        ForEach(mainPageViewModel.selectedItem!.items.indices, id:\.self) {index in
                            HStack {
                                makeImage(url: URL(string: mainPageViewModel.selectedItem!.items[index].image))
                                    .padding(0)
                                    .frame(height: 100)
                                    .frame(width: 150)
                                VStack(alignment: .leading) {
                                    if mainPageViewModel.selectedItem!.items[index].chineseTitle != nil {
                                        Text(mainPageViewModel.selectedItem!.items[index].chineseTitle!)
                                            .font(.system(size: 16))
                                            .padding(0)
                                    } else {
                                        Text(mainPageViewModel.selectedItem!.items[index].title)
                                            .font(.system(size: 16))
                                            .padding(0)
                                    }
                                    
                                    Text(mainPageViewModel.selectedItem!.items[index].kind)
                                        .font(.system(size: 16))
                                        .padding(0)
                                    Text(mainPageViewModel.selectedItem!.items[index].subtitle)
                                        .font(.system(size: 16))
                                        .padding(0)
                                }
                                .padding(0)
                                Spacer()
                            }
                        }
                        
                        Divider()
                            .padding(.top, 20)
                        
                        HStack() {
                            Text("包含")
                                .bold()
                                .font(.system(size: 24))
                            Spacer()
                        }
                        VStack(alignment: .leading) {
                            ForEach(mainPageViewModel.selectedItem!.chineseAlsoContains!.split(separator: "#"), id:\.self) {item in
                                HStack {
                                    Text(item)
                                        .font(.system(size: 18))
                                    Spacer()
                                }
                            }
                        }
                        if mainPageViewModel.selectedItem!.rawData.count > 1 {
                            VStack(alignment: .leading) {
                                Divider()
                                HStack() {
                                    Text("已折叠")
                                        .bold()
                                        .font(.system(size: 24))
                                    Spacer()
                                }
                                ForEach(mainPageViewModel.selectedItem!.rawData, id: \.id) { item in
                                    Text("id: \(String(item.id)), 入库时间: \(item.date)")
                                }
                            }

                        }
                        
                        
                        Spacer()
                        Button("关闭") {
                            isBottomSheetPresented = false
                        }
                    }.padding(.all, 20)
                }
                .padding(.all, 0)
            }
            .padding(.all, 0)
            Spacer()
        }
        .background(Color.gray.opacity(0.04))
        .padding(.all, 0)
        .ignoresSafeArea()
    }
    
    func makeImage(url: URL?) -> some View {

        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .cornerRadius(4)
    }
    
}
