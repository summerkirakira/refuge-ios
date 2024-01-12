//
//  BuybackItemListView.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/8.
//

import SwiftUI
import NukeUI

@available(iOS 14.0, *)
@MainActor
struct BuybackListItemView: View {
    @Binding var data: BuybackItem
    @State var isShowReclaimModeAlert = false
    @State var isShowReclaimWarningAlert = false
    @State var relaimMode = 0
    @StateObject var mainViewModel: MainPageViewModel
    var body: some View {
        HStack {
            makeImage(url: URL(string: data.image)!)
                .overlay {
                    makeDial(num: data.number)
                        .position(x: 84, y:84)
                    if (data.name.contains("Warbond")) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color("ColorWarbond"))
                            .frame(width: 30, height: 20)
                            .overlay {
                                Text("WB")
                                    .foregroundColor(.white)
                                    .minimumScaleFactor(0.5)
                            }
                            .position(x: 85, y: 10)
                    }
                }
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        if (mainViewModel.isTranslationEnabled) {
                            Text(data.chineseName)
                                .font(.system(size: 16))
                                .bold()
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 8)
                        } else {
                            Text(data.name)
                                .font(.system(size: 16))
                                .bold()
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.leading, 8)
                        }
                        
                        
                    }
                    Spacer()
                }
                Spacer()
                HStack {
//                    HStack {
//                        Text("$\(data.price / 100)")
//                            .font(.system(size: 20))
//                            .bold()
//                            .minimumScaleFactor(0.5)
//                    }
                    Spacer()
                    VStack {
                        Text(data.date)
                        .font(.system(size: 12))
                    }
                }.padding(.all, 0)
            }
        }
//        .background(Color.gray.opacity(0.01))
        .frame(height: 100)
        .padding(.vertical, 5)
        .padding(.horizontal, 8)
    }
    
    private let pipeline = ImagePipeline()
    
    func makeImage(url: URL) -> some View {
        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .frame(height: 100)
            .frame(width: 100)
            .cornerRadius(4)
    }
    
    func makeTag(color: Color, text: String) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(color, lineWidth: 1)
            .frame(height: 22)
            .frame(width: 40)
            .overlay(
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(color)
            )
            .padding(0)
    }
    
    func makeDial(num: Int) -> some View {
        Circle()
            .fill(Color("ItemNumberDialBlue"))
            .frame(height: 30)
            .frame(width: 30)
            .overlay(
                Text("+\(data.number)")
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.5)
            )
//            .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}
