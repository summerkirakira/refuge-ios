//
//  Utils.swift
//  Refuge
//
//  Created by Summerkirakira on 27/11/2023.
//

import Foundation


func getHangarItemKey(hangarItem: HangarItem) -> String {
    var key = hangarItem.name
    key += hangarItem.image
    key += hangarItem.tags.map { tag in
        tag.name
    }.joined(separator: "#")
    key += hangarItem.alsoContains
    return key
}


func concatSamePakage(hangarItems: [HangarItem]) -> [HangarItem] {
    var itemDict: [String: Int] = [:]
    var itemList: [HangarItem] = []
    var currentNumber = 0
    
    for hangarItem in hangarItems {
        let key = getHangarItemKey(hangarItem: hangarItem)
        if itemDict.keys.contains(key) {
            let itemNum = itemDict[key]
            itemList[itemNum!].idList.append(hangarItem.id)
            itemList[itemNum!].number += 1
            itemList[itemNum!].rawData.append(hangarItem)
        } else {
            itemDict[key] = currentNumber
            currentNumber += 1
            var newHangarItem = hangarItem
            newHangarItem.rawData.append(hangarItem)
            itemList.append(newHangarItem)
        }
    }
    return itemList
}
