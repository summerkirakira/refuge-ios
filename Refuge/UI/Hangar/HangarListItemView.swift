//
//  HangarListViewItem.swift
//  Refuge
//
//  Created by 弘培郑 on 22/12/2022.
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
                        .position(x: 84, y:84)
                )
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        Text(data.name)
                            .font(.system(size: 18))
                            .bold()
                            .lineLimit(2)
                        Spacer()
                    }
                    Spacer()
                }
                HStack {
                    if (data.status=="库存中") {
                        makeTag(color: Color("InHangarGreen"), text: data.status)
                    }
                    ForEach(data.tags) { tag in
                        if (tag.name == "可回收") {
                            makeTag(color: Color("ReclaimableGrey"), text: tag.name)
                        }
                        if (tag.name == "可升级") {
                            makeTag(color: Color("CanUpgradeBlue"), text: tag.name)
                        }
                        if (tag.name == "可礼物") {
                            makeTag(color: Color("GiftablePink"), text: tag.name)
                        }
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Text("$\(data.price/100)")
                        .font(.system(size: 30))
                        .bold()
                    Spacer()
                    VStack {
                        Spacer()
                        Text(data.date)
                    }
                }
            }
        }
        .frame(height: 100)
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
    }
    
    func makeDial(num: Int) -> some View {
        Circle()
            .fill(Color("ItemNumberDialBlue"))
            .frame(height: 30)
            .frame(width: 30)
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
