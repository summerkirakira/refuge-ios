//
//  UtilityPage.swift
//  Refuge
//
//  Created by Summerkirakira on 2023/12/22.
//

import Foundation
import NukeUI
import SwiftUI


struct UtilityPage: View {
    @ObservedObject var mainPageViewModel: MainPageViewModel
    @State var bannerPosition = 0
    private let pipeline = ImagePipeline()
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $bannerPosition) {
                ForEach(mainPageViewModel.banners.indices, id:\.self) {index in
                    makeImage(url: URL(string: mainPageViewModel.banners[index].url)!)
                        .ignoresSafeArea()
                        .tag(index)
                }
            }
            .padding(.all, 0)
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle())
            .ignoresSafeArea()
            .padding(.all, 0)
            VStack {
                HStack {
                    VStack {
                        Image("ic_hangar_main")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("我的机库")
                            .font(.system(size: 10))
                            .foregroundColor(Color.black).opacity(0.75)
                    }
                    .onTapGesture {
                        
                    }
//                    VStack {
//                        Image(systemName: "sparkles")
//                        Text("我的机库")
//                            .font(.system(size: 10))
//                    }
//                    VStack {
//                        Image(systemName: "sparkles")
//                        Text("我的机库")
//                            .font(.system(size: 10))
//                    }
//                    VStack {
//                        Image(systemName: "sparkles")
//                        Text("我的机库")
//                            .font(.system(size: 10))
//                    }
//                    VStack {
//                        Image(systemName: "sparkles")
//                        Text("我的机库")
//                            .font(.system(size: 10))
//                    }
                    
                }
            }
            .padding(.top, 10)
            Spacer()
        }
        .background(Color.gray.opacity(0.04))
        .padding(.all, 0)
        .ignoresSafeArea()
        .onAppear {
            bannerPosition = Int.random(in: 0...mainPageViewModel.banners.count)
//            changeBannerPositionTask()
        }
    }
    
    func makeImage(url: URL) -> some View {
        LazyImage(source: url)
            .animation(.default)
            .pipeline(pipeline)
            .frame(height: 300)
    }
    
    func changeBannerPositionTask() {
            DispatchQueue.global().async {
                while(true) {
                    if bannerPosition >= mainPageViewModel.banners.count - 1 {
                        bannerPosition = 0
                    } else {
                        bannerPosition += 1
                    }
                    sleep(5)
                }
            }
        }
}
