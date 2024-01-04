//
//  HangarItemRepository.swift
//  Refuge
//
//  Created by Summerkirakira on 03/01/2024.
//

import CoreData
import Foundation

public class UpgradeRepository: ObservableObject{
    @Published var items: [ShipUpgradeInfo] = []
    
    static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("upgrade_item.data")
    }
    
    @discardableResult
    func load() async throws -> [ShipUpgradeInfo] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let hangarItems):
                    continuation.resume(returning: hangarItems)
                }
            }
        }
    }
    
    func load(completion: @escaping (Result<[ShipUpgradeInfo], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try UpgradeRepository.fileURL()
                let hangarItems = try loadArrayFromJSON(ShipUpgradeInfo.self, from: fileURL)
                DispatchQueue.main.async {
                    self.items = hangarItems
                    completion(.success(hangarItems))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
            }
        }
    }
    
    func loadSync() {
        do {
            let fileURL = try UpgradeRepository.fileURL()
            let hangarItems = try loadArrayFromJSON(ShipUpgradeInfo.self, from: fileURL)
            self.items = hangarItems
        } catch {
            self.items = []
        }
    }
    
    func saveSync(items: [ShipUpgradeInfo]) {
        do {
            let outfile = try UpgradeRepository.fileURL()
            try saveArrayAsJSON(items, to: outfile)
            self.items = items
        } catch {
            
        }
    }
    
    
    
    func refresh(needRefreshToken: Bool) async {
        if needRefreshToken {
            let token = try? await RsiApi.getAuthToken()
            let contextToken = try? await RsiApi.getUpgradeContextToken()
        }
        let upgradeData = await initShipUpgrade()
        let ships = upgradeData?.data.ships
        if ships != nil {
            saveSync(items: ships!)
            self.items = ships!
        }
    }
    
    func getFilteredUpgradeList() async -> [UpgradeListItem] {
        let filterData = await getUpgradeFromShip(toShipId: nil)
        
        var shipUpgradeList: [UpgradeListItem] = []
        for ship in filterData!.data.to.ships {
            for sku in ship.skus {
                let shipUpgrade = getUpgradeListItemById(skuId: sku.id)
                if shipUpgrade != nil {
                    shipUpgradeList.append(shipUpgrade!)
                }
            }
        }
        return shipUpgradeList
    }
    
    
    func getUpgradeListItemById(skuId: Int) -> UpgradeListItem? {
        for item in self.items {
            if item.skus != nil {
                for sku in item.skus! {
                    if sku.id == skuId {
                        let shipAlias = getShipAlias(shipName: item.name)
                        var shipChineseName = translateItem(name: item.name)
                        var type = ShipUpgradeType.OTHER
                        if sku.title.contains("Standard") {
                            type = ShipUpgradeType.STANDARD
                        } else if (sku.title.contains("Subscribers")) {
                            type = ShipUpgradeType.SUBSCRIBER
                        } else if (sku.title.contains("Warbond")) {
                            type = ShipUpgradeType.WARBOND
                        }
                        return UpgradeListItem(skuId: skuId, shipAlias: shipAlias, price: sku.price, chineseName: shipChineseName, upgradeName: sku.title, detail: item, type: type)
                    }
                }
            }
        }
        return nil
    }
    

}

public let upgradeRepo = UpgradeRepository()
