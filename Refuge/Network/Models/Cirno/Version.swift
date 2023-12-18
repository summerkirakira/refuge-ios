//
//  Version.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation

struct Version: Identifiable, Codable {
    public var id: Int
    public var version: String
    public var shipDetailVersion: String
    public var shipAliasUrl: String
}

struct Translation: Identifiable, Codable {
    public var id: Int
    public var english_title: String
    public var title: String
}

struct TranslationVersion: Codable {
    public var version: String
}



struct ShipAlias: Identifiable, Codable {
    
    struct Sku: Codable {
        public var title: String
        public var price: Int
    }
    
    public var id: Int
    public var name: String
    public var alias: [String]
    public var skus: [Sku]
    func getHighestSkuPrice() -> Int {
        var highestPrice = 0
        for sku in skus {
            if sku.price > highestPrice {
                highestPrice = sku.price
            }
        }
        return highestPrice
    }

}
