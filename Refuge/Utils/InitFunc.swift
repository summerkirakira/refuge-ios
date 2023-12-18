//
//  InitFunc.swift
//  Refuge
//
//  Created by Summerkirakira on 17/12/2023.
//

import Foundation

let defaults = UserDefaults.standard

var shipAliases: [ShipAlias] = []
var translationDict = [String: String]()

func getUuid() -> String {
    if let uuid = defaults.string(forKey: "uuid") {
        return uuid
    } else {
        let uuid = UUID().uuidString
        defaults.set(uuid, forKey: "uuid")
        return uuid
    }
}

func checkShipAlias(shipAliasUrl: String) async {
    let newVersion = shipAliasUrl.split(separator: "/").last!.replacingOccurrences(of: "formatted_ship_alias.", with: "").replacingOccurrences(of: ".json", with: "")
    let currentVersion = defaults.string(forKey: "shipAliasVersion") ?? "0.0.0"
    let result = compareVersions(currentVersion, newVersion)
    let shipAliasPath = getDocumentsDirectory().appendingPathComponent("shipAlias.json")
    if result == .orderedAscending {
        let shipAlias = await CirnoApi.getShipAlias(url: URL(string: shipAliasUrl)!)
        debugPrint(shipAlias)
        try! saveArrayAsJSON(shipAlias, to: shipAliasPath)
        defaults.set(newVersion, forKey: "shipAliasVersion")
    }
    do {
        shipAliases = try loadArrayFromJSON(ShipAlias.self, from: shipAliasPath)
    } catch {
        debugPrint("Load ShipAlias Failed")
    }
}

func checkTranslations(version: TranslationVersion) async -> [String: String] {
    let currentVersion = defaults.string(forKey: "translationVersion") ?? "0.0.0"
    let result = compareVersions(currentVersion, version.version)
    if result == .orderedAscending {
        var translationDict = [String: String]()
        let translations = await CirnoApi.getTranslation()
        for translation in translations {
            translationDict[translation.english_title] = translation.title
        }
        saveDictionaryToPlist(translationDict, dictName: "translationDict")
        defaults.set(version.version, forKey: "translationVersion")
    }
    let translations = loadDictionaryFromPlist(dictName: "translationDict")
    return translations!
}

func appInit() async {
    let version = await CirnoApi.getTranslationVersion()
    if version != nil {
        translationDict = await checkTranslations(version: version!)
    }
    
    
    await checkShipAlias(shipAliasUrl: "https://image.biaoju.site/starcitizen/formatted_ship_alias.1.0.9.json")
}
