//
//  UpgradeListItemView.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/3.
//

import SwiftUI
import NukeUI

@available(iOS 14.0, *)
@MainActor
struct UpgradeListItemView: View {
    @Binding var data: UpgradeListItem
    @StateObject var mainViewModel: MainPageViewModel
    var body: some View {
        HStack {
            makeImage(url: URL(string: data.detail.medias.slideShow)!)
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        if (mainViewModel.isTranslationEnabled || data.shipAlias == nil) {
                            Text(data.chineseName)
                                .font(.system(size: 16))
                                .bold()
                                .padding(.bottom, 5)
                                .padding(.horizontal, 5)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        } else {
                            Text(data.shipAlias!.name)
                                .font(.system(size: 16))
                                .bold()
                                .padding(.bottom, 5)
                                .padding(.horizontal, 5)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        
                    }
                    Spacer()
                }
                HStack {
                    Text("可升级")
                        .font(.system(size: 14))
                        .padding(.vertical, 5)
                        .padding(.horizontal, 5)
                    Spacer()
                }
                Spacer()
                HStack {
                    HStack {
                        Text("$\(data.price / 100)")
                            .font(.system(size: 22))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 5)
                            .minimumScaleFactor(0.5)
//                        if (data.shipAlias != nil) {
//                            Text("$\(data.shipAlias.ge / 100)")
//                                .font(.system(size: 20))
//                                .bold()
//                                .minimumScaleFactor(0.5)
//                                .foregroundColor(.green)
//                        }
                        
                    }
                    Spacer()
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
            .frame(width: 170)
            .cornerRadius(4)
    }
}
