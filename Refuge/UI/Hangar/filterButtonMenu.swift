//
//  filterButtonMenu.swift
//  Refuge
//
//  Created by Summerkirakira on 2023/12/23.
//

import Foundation
import SwiftUI

enum SortType {
    case Price
    case CurrentPrice
    case Time
}

enum FilterType {
    case Upgrade
    case FPS
    case Warbond
    case Pakage
    case Ship
    case Skin
    case None
}

struct FilterButtonMenu: View {
    @StateObject var mainViewModel: MainPageViewModel
//    @Binding var topBarColorString: String
    @State private var reverseOrder: Bool = true
    @State private var sortType = SortType.Time
    @State private var filterType = FilterType.None
    var body: some View {
        Menu {
            Menu {
                Button("正序") {
                    reverseOrder = false
                }
                Button("倒序") {
                    reverseOrder = true
                }
            } label: {
                Text("排序")
            }
            Menu {
                Button("按当前价格") {
                    sortType = SortType.CurrentPrice
                }
                Button("按实际价格") {
                    sortType = SortType.Price
                }
                Button("按入库时间") {
                    sortType = SortType.Time
                }
            } label: {
                Text("排序选项")
            }
            Menu {
                Button("取消筛选") {
                    filterType = FilterType.None
                }
                Button("舰船升级") {
                    filterType = FilterType.Upgrade
                }
                Button("个人装备") {
                    filterType = FilterType.FPS
                }
                Button("战争债券") {
                    filterType = FilterType.Warbond
                }
                Button("组合包") {
                    filterType = FilterType.Pakage
                }
                Button("舰船") {
                    filterType = FilterType.Ship
                }
                Button("涂装") {
                    filterType = FilterType.Skin
                }
            } label: {
                Text("筛选")
            }
            
        } label: {
            Image(systemName: "list.bullet")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color("ColorTopBarBlack"))
                .padding(.horizontal, 20)
        }
        .onChange(of: reverseOrder) { newValue in
            filterHangar()
            sortHangar()
        }
        .onChange(of: filterType) { newValue in
            filterHangar()
            sortHangar()
        }
        .onChange(of: sortType) { newValue in
            filterHangar()
            sortHangar()
        }
    }
    
    func filterHangar() {
        switch(filterType) {
        case FilterType.Upgrade:
            mainViewModel.hangarItems = repository.items.filter { item in
                let types = getHangarItemTypes(item: item)
                if types.contains(HangarItemType.Upgrade) {
                    return true
                } else {
                    return false
                }
            }
        case FilterType.FPS:
            mainViewModel.hangarItems = repository.items.filter { item in
                let types = getHangarItemTypes(item: item)
                if types.contains(HangarItemType.FPS) {
                    return true
                } else {
                    return false
                }
            }
        case FilterType.Pakage:
            mainViewModel.hangarItems = repository.items.filter { item in
                let types = getHangarItemTypes(item: item)
                if types.contains(HangarItemType.Pakage) {
                    return true
                } else {
                    return false
                }
            }
        case FilterType.Ship:
            mainViewModel.hangarItems = repository.items.filter { item in
                let types = getHangarItemTypes(item: item)
                if types.contains(HangarItemType.Ship) {
                    return true
                } else {
                    return false
                }
            }
        case FilterType.Skin:
            mainViewModel.hangarItems = repository.items.filter { item in
                let types = getHangarItemTypes(item: item)
                if types.contains(HangarItemType.Skin) {
                    return true
                } else {
                    return false
                }
            }
        case FilterType.Warbond:
            mainViewModel.hangarItems = repository.items.filter { item in
                let types = getHangarItemTypes(item: item)
                if types.contains(HangarItemType.Warbond) {
                    return true
                } else {
                    return false
                }
            }
        case FilterType.None:
            mainViewModel.hangarItems = repository.items
        }
    }
    
    func sortHangar() {
        mainViewModel.hangarItems.sort {
            switch(sortType) {
            case SortType.Time:
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy年MM月dd日"
                let date0 = dateFormatter.date(from: $0.date)
                let date1 = dateFormatter.date(from: $1.date)
                if date0 != nil && date1 != nil {
                    return (date0! > date1!) == reverseOrder
                }
                return true
            case SortType.Price:
                return ($0.price > $1.price) == reverseOrder
            case SortType.CurrentPrice:
                return ($0.currentPrice > $1.currentPrice) == reverseOrder
            }
        }
    }
    
}
