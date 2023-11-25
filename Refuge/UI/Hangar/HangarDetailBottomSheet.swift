//
//  HangarDetailBottomSheet.swift
//  Refuge
//
//  Created by Summerkirakira on 25/11/2023.
//

import Foundation
import SwiftUI


struct HangarBottomSheet<DetailContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> DetailContent

    func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                .onTapGesture {
                    // 点击底部表单内容时不关闭底部表单
                }
            Spacer()
        }
        .background(Color.black.opacity(0.3).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            // 点击背景关闭底部表单
            isPresented = false
        }
        .animation(.easeInOut)
    }
}

extension View {
    func hangarBottomSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self.modifier(HangarBottomSheet(isPresented: isPresented, content: content))
    }
}
