//
//  UpgradeFunc.swift
//  Refuge
//
//  Created by Summerkirakira on 2024/1/3.
//

import Foundation

func initShipUpgrade(rsiAPI: RSIApi = RsiApi) async -> InitUpgradeProperty? {
    let result = await rsiAPI.initShipUpgrade()
    return result
}

func getUpgradeFromShip(rsiAPI: RSIApi = RsiApi, toShipId: Int?) async -> FilterShipUpgradeProperty? {
    let result = await rsiAPI.getUpgradeFromShip(toShipId: toShipId)
    return result
}
