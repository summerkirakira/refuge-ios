//
//  HangarParser.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation

import SwiftSoup

enum ParserError: Error {
    case customErrot(String)
}


func priceStringToInt(priceString: String) -> Int {
    var price = 0
    if (!priceString.contains("UEC")) {
        let ad = priceString.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " USD", with: "").replacingOccurrences(of: ",", with: "")
        price = Int(Float(priceString.replacingOccurrences(of: "$", with: "").replacingOccurrences(of: " USD", with: "").replacingOccurrences(of: ",", with: ""))!)
    }
    return price
}

func imageStringToUrl(imageString: String) -> String {
    return imageString.replacingOccurrences(of: "background-image:url('", with: "").replacingOccurrences(of: "');", with: "")
}

func convertDate(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM dd, yyyy"
    let dateObj = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "yyyy年MM月dd日"
    return dateFormatter.string(from: dateObj!)
}


func getHangarItems(content: String) throws -> [HangarItem] {
    var hangarItems: [HangarItem] = []
    let doc: Document? = try? SwiftSoup.parse(content)
    
    if doc == nil {
        throw ParserError.customErrot("解析错误")
    }
    
    let pledgeList: Elements? = try? doc!.select(".list-items").first()!.select(".row")
    if pledgeList == nil {
        throw ParserError.customErrot("未找到机库内容")
    }
    do {
        for pledge in pledgeList! {
            let pledgeId = try Int(pledge.select(".js-pledge-id").first()!.attr("value"))
            let pledgeValueString = try pledge.select(".js-pledge-value").first()!.attr("value")
            let pledgeValue: Int = priceStringToInt(priceString: String(pledgeValueString))
            let pledgeImage = try imageStringToUrl(imageString: pledge.select("div.image").first()!.attr("style"))
            var pledgeTitle = try pledge.select(".js-pledge-name").first()!.attr("value")
            if (pledgeTitle.contains("nameable ship") && pledgeTitle.contains(" Contains ")) {
                pledgeTitle = pledgeTitle.components(separatedBy: " Contains ")[0]
            }
            let pledgeStatus = try pledge.select(".availability").first()!.text()
            let pledgeDate = try convertDate(date: pledge.select(".date-col").first()!.text().replacingOccurrences(of: "Created: ", with: ""))
            let pledgeContains = try pledge.select(".items-col").first()!.text().replacingOccurrences(of: "Contains:", with: "")
            let canGift = try !pledge.select(".shadow-button.js-gift").isEmpty()
            let canExchange = try !pledge.select(".shadow-button.js-reclaim").isEmpty()
            let canUpgrade = try !pledge.select(".shadow-button.js-apply-upgrade").isEmpty()
            let upgradeInfo = try pledge.select(".js-upgrade-data").first()
            let isUpgrade = upgradeInfo == nil ? false : true
            let alsoContainsItemString = try pledge.select(".title").map({ element in
                try element.text()
            }).joined(separator: "#")
            let items: [HangarSubItem] = try pledge.select(".with-images").first()!.select(".item").map{ item in
                let id: String = String(pledgeId!)
                let title = try item.select(".title").first()!.text()
                let image = imageStringToUrl(imageString: try item.select(".image").first()!.attr("style"))
                var kind = try? item.select(".kind").first()
                var kindString = try? kind == nil ? "" : kind!.text()
                var subtitle = try? item.select(".liner").first()
                var subtitleString = try? subtitle == nil ? "" : subtitle!.text()
                return HangarSubItem(
                    id: id,
                    image: image,
                    package_id: pledgeId!,
                    title: title,
                    kind: kindString!,
                    subtitle: subtitleString!,
                    insert_time: 777,
                    chineseSubtitle: "Test123",
                    chineseTitle: "Test2332x"
                )
            }
            hangarItems.append(
                HangarItem(
                    id: pledgeId!,
                    name: pledgeTitle,
                    chineseName: pledgeTitle,
                    image: pledgeImage,
                    number: 1,
                    status: pledgeStatus,
                    tags: [],
                    date: pledgeDate,
                    contains: alsoContainsItemString,
                    price: pledgeValue,
                    insurance: "12M",
                    alsoContains: alsoContainsItemString,
                    items: items,
                    isUpgrade: isUpgrade,
                    chineseAlsoContains: alsoContainsItemString
                )
            )
        }
    } catch {
        throw ParserError.customErrot("机库解析错误")
    }
    return hangarItems
}


