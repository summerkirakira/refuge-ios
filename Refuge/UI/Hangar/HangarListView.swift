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
    @ObservedObject var hangarItemRepository: HangarItemRepository = repository
    @State var currentSelected: HangarItem? = nil
    @State var searchString: String = ""
    @State var currentDisplayHangarItem: HangarItem?
    private let pipeline = ImagePipeline()
    
    var body: some View {
        VStack {
            List{
//                SearchBar(searchText: $searchString)
                ForEach(hangarItemRepository.items.indices, id:\.self) {index in
                    HangarListItemView(data: $hangarItemRepository.items[index])
                        .onTapGesture {
                            currentDisplayHangarItem = $hangarItemRepository.items[index].wrappedValue
                            Task {
//                                let token = await recaptchaV3.getRecaptchaToken()
//                                debugPrint(token)
                            }

                    }
                }
            }
            .listRowInsets(EdgeInsets())
            .refreshable {
                await hangarItemRepository.refreshHangar()
            }
            .searchable(text: $searchString) {
                
            }
            .sheet(isPresented: currentDisplayHangarItem != nil ? .constant(true) : .constant(false)) {
                ScrollView {
                    VStack {
                        HStack {
                            makeImage(url: URL(string: currentDisplayHangarItem!.image))
                                .frame(height: 130)
                                .frame(width: 130)
                            VStack(alignment: .leading) {
                                if currentDisplayHangarItem!.chineseName != nil {
                                    Text(currentDisplayHangarItem!.chineseName!)
                                        .bold()
                                        .lineLimit(2)
                                        .font(.system(size: 20))
                                        .padding(.all, 0)
                                }
                                Text(currentDisplayHangarItem!.name)
                                    .font(.system(size: 14))
                                    .lineLimit(3)
                                    .padding(.all, 0)
                                    .padding(.top, 5)
                            }
                            Spacer()
                        }
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
                        
                        ForEach(currentDisplayHangarItem!.items.indices, id:\.self) {index in
                            HStack {
                                makeImage(url: URL(string: currentDisplayHangarItem!.items[index].image))
                                    .padding(0)
                                    .frame(height: 100)
                                    .frame(width: 150)
                                VStack(alignment: .leading) {
                                    Text(currentDisplayHangarItem!.items[index].title)
                                        .font(.system(size: 16))
                                        .padding(0)
                                    Text(currentDisplayHangarItem!.items[index].kind)
                                        .font(.system(size: 16))
                                        .padding(0)
                                    Text(currentDisplayHangarItem!.items[index].subtitle)
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
                            ForEach(currentDisplayHangarItem!.chineseAlsoContains!.split(separator: "#"), id:\.self) {item in
                                HStack {
                                    Text(item)
                                        .font(.system(size: 18))
                                    Spacer()
                                }
                            }
                        }
                        if currentDisplayHangarItem!.rawData.count > 1 {
                            VStack(alignment: .leading) {
                                Divider()
                                HStack() {
                                    Text("已折叠")
                                        .bold()
                                        .font(.system(size: 24))
                                    Spacer()
                                }
                                ForEach(currentDisplayHangarItem!.rawData, id: \.id) { item in
                                    Text("id: \(String(item.id)), 入库时间: \(item.date)")
                                }
                            }

                        }
                        
                        
                        Spacer()
                        Button("关闭") {
                            currentDisplayHangarItem = nil
                        }
                    }.padding(.all, 20)
                }
                .padding(.all, 0)
            }
            .padding(.all, 0)
            Spacer()
        }
        .padding(.all, 0)
    }
    
    func refreshHangar() async {
        hangarItemRepository.items.append(HangarItem.sampleData)
        do {
            try await hangarItemRepository.save()
        } catch {
            
        }
        
    }
    
    func makeImage(url: URL?) -> some View {

        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .cornerRadius(4)
    }
    
}

struct HangarListView_Previews: PreviewProvider {
    static var previews: some View {
        HangarListView()
    }
}
