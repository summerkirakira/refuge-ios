//
//  HangarItemProperty.swift
//  Refuge
//
//  Created by Summerkirakira on 22/12/2022.
//

import Foundation
import CoreData

struct HangarSubItem: Codable {
    let id: String
    let image: String
    let package_id: Int
    let title: String
    var kind: String
    var subtitle: String
    let insert_time: Int
    var chineseSubtitle: String? = nil
    var chineseTitle: String? = nil
}

struct Tag: Identifiable, Codable {
    let name: String
    let color: String
    var id: String {
        name
    }
}

struct HangarItem: Identifiable, Codable {
    let id: Int
    var idList: String = ""
    let name: String
    var chineseName: String? = nil
    let image: String
    var number: Int
    var status: String
    let tags: [Tag]
    let date: String
    let contains: String
    let price: Int
    var insurance: String
    let alsoContains: String
    let items: [HangarSubItem]
    var isUpgrade: Bool = false
    var formShipId: Int = 0
    var toShipId: Int = 0
    var toSkuId: Int = 0
    var chineseAlsoContains: String? = nil
}

#if DEBUG

extension HangarSubItem {
    static let sampleData: HangarSubItem = HangarSubItem(id: "1422", image: "https://media.robertsspaceindustries.com/lh1i6amg77crm/heap_infobox.jpg", package_id: 3723, title: "LUMINALIA 2952 DAY 12 ADVENT ITEM", kind: "FPS", subtitle: "RSI", insert_time: 1671705774)
}

extension HangarItem {
    static let sampleData: HangarItem = HangarItem(id: 23123, name: "UPGRADE - PROWLER TO HULL D STANDARD EDITION", chineseName: "光灯节第12天奖励光灯节第12天奖励", image: "https://media.robertsspaceindustries.com/lh1i6amg77crm/heap_infobox.jpg", number: 3, status: "库存中", tags: [Tag(name: "可回收", color: ""), Tag(name: "可礼物", color: ""), Tag(name: "可升级", color: "")], date: "2022年12月19日", contains: "", price: 2000, insurance: "LTI", alsoContains: "", items: [HangarSubItem.sampleData, HangarSubItem.sampleData, HangarSubItem.sampleData], chineseAlsoContains: "Hello#world#Razor - Foundation Fest Paint")
}

#endif
