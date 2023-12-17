//
//  ShipInfoTabView.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import SwiftUI

struct ShipInfoTabView: View {
    var body: some View {
        TabView {
              Text("First tab")
                .tabItem {
                  Image(systemName: "1.circle")
                  Text("First")
                }
                HangarListView()
                .tabItem {
                  Image(systemName: "2.circle")
                  Text("机库")
                }
                HangarListView()
                .padding(0)
                .tabItem {
                  Image(systemName: "3.circle")
                  Text("Third")
                }
            ContentView()
                .tabItem {
                  Image(systemName: "4.circle")
                  Text("Fourth")
                }
            }
        .tabViewStyle(.automatic)
        
    }
}

struct ShipInfoTabView_Previews: PreviewProvider {
    static var previews: some View {
        ShipInfoTabView()
    }
}

