//
//  HangarListView.swift
//  Refuge
//
//  Created by 弘培郑 on 22/12/2022.
//

import SwiftUI

struct HangarListView: View {
    @ObservedObject var hangarItemRepository: HangarItemRepository = repository
    @State var currentSelected: HangarItem? = nil
    @State var searchString: String = ""
    
    var body: some View {
        List(hangarItemRepository.items.indices, id:\.self) {index in
            HangarListItemView(data: $hangarItemRepository.items[index])
        }
        .refreshable {
            await refreshHangar()
        }
        .searchable(text: $searchString) {
            
        }
        
    }
    
    func refreshHangar() async {
        hangarItemRepository.items.append(HangarItem.sampleData)
        do {
            try await hangarItemRepository.save()
        } catch {
            
        }
        
    }
    
}

struct HangarListView_Previews: PreviewProvider {
    static var previews: some View {
        HangarListView()
    }
}
