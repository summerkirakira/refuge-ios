//
//  BuybackProperty.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/8.
//

import Foundation


struct BuybackItem: Decodable, Encodable {
    var number = 1
    var pledgeId: Int
    var name: String
    var chineseName: String
    var image: String
    var date: String
    var contains: String
    var isUpgrade: Bool
    var fromShipId: Int
    var toShipId: Int
    var toSkuId: Int
    var chineseContains: String
    var chineseAlsoContains: String
    var price = 0
}
