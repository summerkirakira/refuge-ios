//
//  BuybackParser.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/8.
//

import Foundation
import SwiftSoup

func getBuybackItems(content: String) throws -> [BuybackItem] {
    var buybackItems: [BuybackItem] = []
    let doc: Document? = try? SwiftSoup.parse(content)
    
    if doc == nil {
        throw ParserError.customError("解析错误")
    }
    
    let pledgeList: Elements? = try? doc?.select("article.pledge")
    if pledgeList == nil {
        throw ParserError.customError("未找到机库内容")
    }
    for pledge in pledgeList! {
        var image = try? pledge.select("img").attr("src")
        if image == nil {
            continue
        }
        if image!.starts(with: "/") {
            image = "https://robertsspaceindustries.com" + image!
        }
        var title = try? pledge.select(".information").first()?.select("h1").first()?.text()
        var timeString = try? pledge.select("dl").first()?.select("dd").first()?.text()
        var contains = try? pledge.select("dl").first()?.select("dd").get(2).text()
        if title == nil && timeString == nil && contains == nil && image == nil {
            continue
        }
        var date = convertDate(date: timeString!)
        var pledgeId = 0
        var isUpgrade = false
        var fromShipId = 0
        var toShipId = 0
        var toSkuId = 0
        
        var buybackUrl = try? pledge.select(".holosmallbtn").attr("href")
        if buybackUrl == nil {
            continue
        }
        if buybackUrl! != "" {
            var itemPledgeString = buybackUrl!.components(separatedBy: "/").last
            if itemPledgeString == nil {
                continue
            }
            var itemPledgeId = Int(itemPledgeString!)
            if itemPledgeId == nil {
                continue
            }
            pledgeId = itemPledgeId!
        } else {
            let buybackButton = try? pledge.select(".holosmallbtn")
            if buybackButton == nil {
                continue
            }
            isUpgrade = true
            pledgeId = parseStringToInt(str: try? buybackButton!.attr("data-pledgeid"))
            fromShipId = parseStringToInt(str: try? buybackButton!.attr("data-fromshipid"))
            toShipId = parseStringToInt(str: try? buybackButton!.attr("data-toshipid"))
            toSkuId = parseStringToInt(str: try? buybackButton!.attr("data-toskuid"))
        }
        buybackItems.append(BuybackItem(pledgeId: pledgeId, name: title!, chineseName: title!, image: image!, date: date, contains: contains!, isUpgrade: isUpgrade, fromShipId: fromShipId, toShipId: toShipId, toSkuId: toSkuId, chineseContains: contains!, chineseAlsoContains: contains!)
                            )
    }
    return buybackItems
}


func parseStringToInt(str: String?) -> Int {
    if str == nil {
        return 0
    }
    let number = Int(str!)
    if number == nil {
        return 0
    } else {
        return number!
    }
}
