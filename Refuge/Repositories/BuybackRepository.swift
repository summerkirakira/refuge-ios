//
//  BuybackRepository.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/8.
//

import Foundation


public class BuybackItemRepository: ObservableObject{
    @Published var items: [BuybackItem] = []
    
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("buyback_item.data")
    }
    
    
    func loadSync() {
        do {
            let fileURL = try BuybackItemRepository.fileURL()
            let hangarItems = try loadArrayFromJSON(BuybackItem.self, from: fileURL)
            self.items = hangarItems
        } catch {
            self.items = []
        }
    }
    
    func saveSync(items: [BuybackItem]) {
        do {
            let outfile = try BuybackItemRepository.fileURL()
            try saveArrayAsJSON(items, to: outfile)
            self.items = items
        } catch {
            
        }
    }
    
    func refresh() async {
        var page = 1
        var totalItems: [BuybackItem] = []
        while(true) {
            do {
                let data = try await RsiApi.getPage(endPoint: "account/buy-back-pledges?page=\(page)&pagesize=100")
                let items = try getBuybackItems(content: data)
                if items.count == 0 {
                    break
                }
//                debugPrint(items)
                totalItems += items
                page += 1
            } catch {
                break
            }
            
        }
//        totalItems = getHangarItemsPrice(hangarItems: totalItems)
        totalItems = concatSameBuyBackPakage(buybackItems: totalItems)
        totalItems = translateBuybackItems(buybackItems: totalItems)
//        totalItems = addTagsToHangarItems(hangarItems: totalItems)
        if (totalItems.count > 0) {
            self.items = totalItems
            self.saveSync(items: self.items)
        }
    }
}

public let buybackRepo = BuybackItemRepository()
