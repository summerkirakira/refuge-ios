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
        tag
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

func getFormattedShipName(shipName: String) -> String {
    let newShipName = shipName
        .replacingOccurrences(of: "Banu", with: "")
        .replacingOccurrences(of: "Drake", with: "")
        .replacingOccurrences(of: "Crusader", with: "")
        .replacingOccurrences(of: "Argo", with: "")
        .replacingOccurrences(of: "Esperia", with: "")
        .replacingOccurrences(of: "Upgrade", with: "")
        .replacingOccurrences(of: "CNOU", with: "")
        .replacingOccurrences(of: "AEGIS", with: "")
        .replacingOccurrences(of: "Mercury Star Runner", with: "Mercury")
        .replacingOccurrences(of: "ORIGIN 600i Exploration Module", with: "600i Explorer")
        .replacingOccurrences(of: "ORIGIN 600i Touring Module", with: "600i Touring")
        .replacingOccurrences(of: "RSI", with: "")
        .replacingOccurrences(of: "Anvil", with: "")
        .replacingOccurrences(of: "Retaliator Base", with: "Retaliator")
        .replacingOccurrences(of: "Mole Carbon Edition", with: "Mole")
        .replacingOccurrences(of: "Genesis Starliner", with: "Genesis")
        .replacingOccurrences(of: "Hercules Starship", with: "")
        .replacingOccurrences(of: "Warbond Subscribers Edition", with: "Warbond Edition")
        .replacingOccurrences(of: "Subscribers Edition", with: "Standard Edition")
        .replacingOccurrences(of: "Mole", with: "MOLE")
    return newShipName.trimmingCharacters(in: .whitespacesAndNewlines)
}

func getFullUpgradeNames(upgradeTitle: String) -> [String] {
    var nameList: [String] = []
    let formattedTitle: String = upgradeTitle.replacingOccurrences(of: "Upgrade - ", with: "")
    for shipName in formattedTitle.components(separatedBy: " to ") {
        nameList.append(getFormattedShipName(shipName: shipName))
    }
    return nameList
}

func getHangarItemPrice(hangarItem: HangarItem) -> HangarItem {
    var newHangarItem = hangarItem
    if hangarItem.isUpgrade {
        let shipNameList = getFullUpgradeNames(upgradeTitle: hangarItem.name)
        let fromShip = getShipAlias(shipName: shipNameList[0])
        let toShip = getShipAlias(shipName: shipNameList[1])
        if fromShip == nil || toShip == nil {
            newHangarItem.currentPrice = -1
            return newHangarItem
        }
        
        if hangarItem.items.count > 0 {
            var newSubItem = hangarItem.items[0]
            newSubItem.fromShipPrice = fromShip!.getHighestSkuPrice()
            newSubItem.toShipPrice = toShip!.getHighestSkuPrice()
            newHangarItem.items = [newSubItem]
        }
        
        let currentPrice = toShip!.getHighestSkuPrice() - fromShip!.getHighestSkuPrice()
        newHangarItem.currentPrice = currentPrice
        return newHangarItem
    } else {
        var currentPrice = 0
        var newSubItemList: [HangarSubItem] = []
        for subItem in hangarItem.items {
            var newSubItem = subItem
            if subItem.kind == "Ship" {
                let shipAlias = getShipAlias(shipName: getFormattedShipName(shipName: subItem.title))
                if shipAlias != nil {
                    let subItemCurrentPrice = shipAlias!.getHighestSkuPrice()
                    currentPrice += subItemCurrentPrice
                    newSubItem.price = subItemCurrentPrice
                }
            }
            newSubItemList.append(newSubItem)
        }
        newHangarItem.items = newSubItemList
        for alsoContain in hangarItem.alsoContains.split(separator: "#") {
            if alsoContain == "Squadron 42 Digital Download" {
                currentPrice += 4500
            }
            if alsoContain == "Star Citizen Digital Download" {
                currentPrice += 4500
            }
        }
        newHangarItem.currentPrice = currentPrice
    }
    return newHangarItem
}

func getHangarItemsPrice(hangarItems: [HangarItem]) -> [HangarItem] {
    var newHangarItems: [HangarItem] = []
    for hangarItem in hangarItems {
        newHangarItems.append(getHangarItemPrice(hangarItem: hangarItem))
    }
    return newHangarItems
}


func translateItem(name: String) -> String {
    if translationDict.keys.contains(name) {
        return translationDict[name]!
    }
    return name
}

func translateHangarString(name: String) -> String {
    var newName = ""
    if name.contains("Upgrade - ") {
        let shipNameList = getFullUpgradeNames(upgradeTitle: name)
        let fromShip = getShipAlias(shipName: shipNameList[0])
        let toShip = getShipAlias(shipName: shipNameList[1])
        var fromShipName = shipNameList[0]
        var toShipName = shipNameList[1]
        if fromShip != nil {
            fromShipName = translateItem(name: fromShip!.name).replacingOccurrences(of: " ", with: "")
        }
        if toShip != nil {
            toShipName = translateItem(name: toShip!.name).replacingOccurrences(of: " ", with: "")
        }
        newName = "升级包 - \(fromShipName) 到 \(toShipName)"
        if name.contains("warbond") {
            newName += "[战争债券版]"
        }
    } else {
        newName = translateItem(name: name)
    }
    return newName
}


func translateHangarItem(hangarItem: HangarItem) -> HangarItem {
    var newHangarItem = hangarItem
    newHangarItem.chineseName = translateHangarString(name: hangarItem.name)
    for i in 0..<newHangarItem.items.count {
        newHangarItem.items[i].chineseTitle = translateHangarString(name: newHangarItem.items[i].title)
    }
    
    var alsoContainList: [String] = []
    for alsoContain in newHangarItem.alsoContains.split(separator: "#") {
        alsoContainList.append(translateHangarString(name: String(alsoContain)))
    }
    newHangarItem.chineseAlsoContains = alsoContainList.joined(separator: "#")
    return newHangarItem
}

func translateHangarItems(hangarItems: [HangarItem]) -> [HangarItem] {
    var newHangarItems: [HangarItem] = []
    for hangarItem in hangarItems {
        newHangarItems.append(translateHangarItem(hangarItem: hangarItem))
    }
    return newHangarItems
}

func addTagsToHangarItem(hangarItem: HangarItem) -> HangarItem {
    var newHangarItem: HangarItem = hangarItem
    if newHangarItem.status == "Attributed" {
        newHangarItem.tags.append("库存中")
    }
    if newHangarItem.status == "Gitfted" {
        newHangarItem.tags.append("已礼物")
    }
    if newHangarItem.canReclaim {
        newHangarItem.tags.append("可回收")
    }
    if newHangarItem.canUpgrade {
        newHangarItem.tags.append("可礼物")
    }
    return newHangarItem
}

func addTagsToHangarItems(hangarItems: [HangarItem]) -> [HangarItem] {
    var newHangarItems: [HangarItem] = []
    for hangarItem in hangarItems {
        newHangarItems.append(addTagsToHangarItem(hangarItem: hangarItem))
    }
    return newHangarItems
}


func getTotalHangarItemPrice(items: [HangarItem]) -> Float {
    var price: Float = 0
    for item in items {
        price += Float(item.price * item.number)
    }
    return price
}

func getTotalCurrentHangarItemPrice(items: [HangarItem]) -> Float {
    var price: Float = 0
    for item in items {
        price += Float(item.currentPrice * item.number)
    }
    return price
}
