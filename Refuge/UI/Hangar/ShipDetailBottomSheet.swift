//
//  ShipDetailBottomSheet.swift
//  Refuge
//
//  Created by Sumemrkirakira on 21/12/2023.
//

import Foundation
import SwiftUI
import NukeUI

struct ShipDetailBottomSheet: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @Binding var isBottomSheetPresented: Bool
    private let pipeline = ImagePipeline()

    var body: some View {
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
                        Spacer()
                        HStack {
                            Text("可融: $\(mainPageViewModel.selectedItem!.price / 100)")
                                .minimumScaleFactor(0.5)
                            Text("当前: $\(mainPageViewModel.selectedItem!.currentPrice / 100)")
                                .foregroundColor(Color.green)
                                .minimumScaleFactor(0.5)
                        }
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
                            
                            
                            if mainPageViewModel.selectedItem!.items[index].fromShipPrice > 0 {
                                HStack {
                                    Text("从")
                                        .font(.system(size: 14))
                                    Text("$\(mainPageViewModel.selectedItem!.items[index].fromShipPrice / 100)")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.green)
                                    Text("到")
                                        .font(.system(size: 14))
                                    Text("$\(mainPageViewModel.selectedItem!.items[index].toShipPrice / 100)")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color.green)
                                }
                            } else {
                                if mainPageViewModel.selectedItem!.items[index].price > 0 {
                                    VStack(alignment: .trailing) {
                                        Text("$\(mainPageViewModel.selectedItem!.items[index].price / 100)")
                                            .foregroundColor(Color.green)
                                    }
                                }
                            }
                            
                            
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
    
    func makeImage(url: URL?) -> some View {

        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .cornerRadius(4)
    }
}
