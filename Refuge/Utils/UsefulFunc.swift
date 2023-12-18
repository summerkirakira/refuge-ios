//
//  UsefulFunc.swift
//  Refuge
//
//  Created by Summerkirakira on 17/12/2023.
//

import Foundation


func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
    let components1 = version1.components(separatedBy: ".")
    let components2 = version2.components(separatedBy: ".")
    
    let maxLength = max(components1.count, components2.count)
    
    for i in 0..<maxLength {
        let value1 = i < components1.count ? Int(components1[i]) ?? 0 : 0
        let value2 = i < components2.count ? Int(components2[i]) ?? 0 : 0
        
        if value1 < value2 {
            return .orderedAscending
        } else if value1 > value2 {
            return .orderedDescending
        }
    }
    
    return .orderedSame
}


func getShipAlias(shipName: String) -> ShipAlias? {
    for shipAlias in shipAliases {
        if shipAlias.name == shipName {
            return shipAlias
        }
        for aliasName in shipAlias.alias {
            if aliasName == shipName {
                return shipAlias
            }
        }
    }
    return nil
}
