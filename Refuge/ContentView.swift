//
//  ContentView.swift
//  Refuge
//
//  Created by Summerkirakira on 22/12/2022.
//

import SwiftUI

struct ContentView: View {
    @State var presentSheet = false
    @Environment(\.managedObjectContext) var moc
    var body: some View {
        Button("Add") {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
