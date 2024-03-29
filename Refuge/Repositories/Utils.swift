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
    key += hangarItem.status
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
        if shipNameList.count != 2 {
            return newHangarItem
        }
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
    } else if (name.contains("Standalone Ship - ")) {
        newName = "单船 - \(translateItem(name: name.replacingOccurrences(of: "Standalone Ship - ", with: "").replacingOccurrences(of: " Upgrades", with: "")))"
    } else {
        newName = translateItem(name: name.replacingOccurrences(of: " Upgrades", with: ""))
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
    if newHangarItem.canReclaim {
        newHangarItem.tags.append("可回收")
    }
    if newHangarItem.canUpgrade {
        newHangarItem.tags.append("可升级")
    }
    if newHangarItem.canGit {
        newHangarItem.tags.append("可礼物")
    }
    if newHangarItem.status == "Gifted" {
        newHangarItem.tags = ["已礼物"]
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

func matchString(str: String?, target: String) -> Bool {
    if str == nil {
        return false
    }
    if str!.range(of: target, options: .caseInsensitive) != nil {
        return true
    }
    return false
}

func isHangarItemMatchedString(hangarItem: HangarItem, searchString: String) -> Bool {
    if searchString == "" {
        return true
    }
    if matchString(str: hangarItem.name, target: searchString) {
        return true
    }
    if matchString(str: hangarItem.chineseName, target: searchString) {
        return true
    }
    if matchString(str: hangarItem.alsoContains, target: searchString) {
        return true
    }
    if matchString(str: hangarItem.chineseAlsoContains, target: searchString) {
        return true
    }
    for item in hangarItem.items {
        if matchString(str: item.title, target: searchString) {
            return true
        }
        if matchString(str: item.chineseTitle, target: searchString) {
            return true
        }
    }
    return false
}

func isBuybackItemMatchedString(hangarItem: BuybackItem, searchString: String) -> Bool {
    if searchString == "" {
        return true
    }
    if matchString(str: hangarItem.name, target: searchString) {
        return true
    }
    if matchString(str: hangarItem.chineseName, target: searchString) {
        return true
    }
    if matchString(str: hangarItem.chineseAlsoContains, target: searchString) {
        return true
    }
    return false
}


func calUserHangarPrice(user: User) -> User {
    var newUser = user
    var currentPrice = 0
    var realPrice = 0
    for item in repository.items {
        currentPrice += item.currentPrice * item.number
        realPrice += item.price * item.number
    }
    newUser.hangarValue = realPrice
    newUser.currentHangarValue = currentPrice
    return newUser
}


enum HangarItemType {
    case Upgrade
    case Warbond
    case Subscribe
    case Skin
    case Pakage
    case Ship
    case FPS
}


func getHangarItemTypes(item: HangarItem) -> [HangarItemType] {
    var types: [HangarItemType] = []
    if item.name.contains("Upgrade") {
        types.append(HangarItemType.Upgrade)
    }
    if item.name.contains("Warbond") {
        types.append(HangarItemType.Warbond)
    }
    for subItem in item.items {
        if subItem.kind == "FPS Equipment" {
            types.append(HangarItemType.FPS)
        }
        if subItem.kind == "Skin" {
            types.append(HangarItemType.Skin)
        }
        if subItem.kind == "Ship" {
            types.append(HangarItemType.Ship)
        }
    }
    if item.items.count > 1 && types.contains(HangarItemType.Ship) {
        types.append(HangarItemType.Pakage)
    }
    return types
}


func concatSameBuyBackPakage(buybackItems: [BuybackItem]) -> [BuybackItem] {
    var itemDict: [String: Int] = [:]
    var itemList: [BuybackItem] = []
    var currentNumber = 0
    
    for hangarItem in buybackItems {
        let key = getBuyBackItemKey(buybackItem: hangarItem)
        if itemDict.keys.contains(key) {
            let itemNum = itemDict[key]
            itemList[itemNum!].number += 1
        } else {
            itemDict[key] = currentNumber
            currentNumber += 1
            var newHangarItem = hangarItem
            itemList.append(newHangarItem)
        }
    }
    return itemList
}

func getBuyBackItemKey(buybackItem: BuybackItem) -> String {
    return "\(buybackItem.name)#\(buybackItem.image)#\(buybackItem.fromShipId)#\(buybackItem.toShipId)#\(buybackItem.toSkuId)"
}


func translateBuybackItem(buybackItem: BuybackItem) -> BuybackItem {
    var newHangarItem = buybackItem
    newHangarItem.chineseName = translateHangarString(name: buybackItem.name)
    
//    var alsoContainList: [String] = []
//    for alsoContain in newHangarItem.alsoContains.split(separator: "#") {
//        alsoContainList.append(translateHangarString(name: String(alsoContain)))
//    }
//    newHangarItem.chineseAlsoContains = alsoContainList.joined(separator: "#")
    return newHangarItem
}

func translateBuybackItems(buybackItems: [BuybackItem]) -> [BuybackItem] {
    var newHangarItems: [BuybackItem] = []
    for hangarItem in buybackItems {
        newHangarItems.append(translateBuybackItem(buybackItem: hangarItem))
    }
    return newHangarItems
}
