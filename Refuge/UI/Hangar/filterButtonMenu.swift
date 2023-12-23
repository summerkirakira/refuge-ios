//
//  filterButtonMenu.swift
//  Refuge
//
//  Created by Summerkirakira on 2023/12/23.
//

import Foundation
import SwiftUI

struct FilterButtonMenu: View {
    @StateObject var mainViewModel: MainPageViewModel
    @Binding var topBarColorString: String
    var body: some View {
        Menu {
            Menu {
                
            } label: {
                Text("排序")
            }
            
        } label: {
            Image("text.alignleft")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(topBarColorString))
        }
    }
}
