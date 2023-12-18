//
//  HangarListViewItem.swift
//  Refuge
//
//  Created by Summerkirakira on 22/12/2022.
//

import SwiftUI
import NukeUI

@available(iOS 14.0, *)
@MainActor
struct HangarListItemView: View {
    @Binding var data: HangarItem
    var body: some View {
        HStack {
            makeImage(url: URL(string: data.image)!)
                .overlay (
                    makeDial(num: data.number)
                        .position(x: 82, y:82)
                )
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        if data.chineseName != nil {
                            Text(data.chineseName!)
                                .font(.system(size: 16))
                                .bold()
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text(data.name)
                                .font(.system(size: 16))
                                .bold()
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    Spacer()
                }

                HStack {
                    if data.tags.contains("库存中") {
                        makeTag(color: Color("InHangarGreen"), text: "库存中")
                    }
                    if data.tags.contains("已礼物") {
                        makeTag(color: Color("GiftablePink"), text: "已礼物")
                    }
                    if data.tags.contains("可回收") {
                        makeTag(color: Color("ReclaimableGrey"), text: "可回收")
                    }
                    if data.tags.contains("可升级") {
                        makeTag(color: Color("CanUpgradeBlue"), text: "可升级")
                    }
                    if data.tags.contains("可礼物") {
                        makeTag(color: Color("GiftablePink"), text: "可礼物")
                    }
                    
//                    ForEach(data.tags) { tag in
//                        if (tag == "可回收") {
//                            makeTag(color: Color("ReclaimableGrey"), text: tag)
//                        }
//                        if (tag == "可升级") {
//                            makeTag(color: Color("CanUpgradeBlue"), text: tag)
//                        }
//                        if (tag == "可礼物") {
//                            makeTag(color: Color("GiftablePink"), text: tag)
//                        }
//                    }
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.bottom, 10)
                Spacer()
                HStack {
                    HStack {
                        Text("$\(data.price / 100)")
                            .font(.system(size: 20))
                            .bold()
                            .minimumScaleFactor(0.5)
                            
                        if (data.currentPrice > 0) {
                            Text("$\(data.currentPrice / 100)")
                                .font(.system(size: 20))
                                .bold()
                                .minimumScaleFactor(0.5)
                                .foregroundColor(.green)
                                
                        }
                    }
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
            .frame(height: 34)
            .frame(width: 34)
            .overlay(
                Text("+\(data.number)")
                    .foregroundColor(.white)
            )
//            .shadow(color: .gray, radius: 2, x: 0, y: 2)
    }
}

struct HangarListItemView_Previews: PreviewProvider {
    static var previews: some View {
//        HangarListItemView()
        ContentView()
    }
}
