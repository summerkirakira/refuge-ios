//
//  InitFunc.swift
//  Refuge
//
//  Created by Summerkirakira on 17/12/2023.
//

import Foundation
import UIKit

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

func getIsTranslationEnabled() -> Bool {
    if let _ = defaults.object(forKey: "is_translation_enabled") {
        let result = defaults.bool(forKey: "is_translation_enabled")
        return result
    } else {
        defaults.set(true, forKey: "is_translation_enabled")
        return true
    }
    
}

func setIsTranslationEnabled(result: Bool){
    defaults.set(result, forKey: "is_translation_enabled")
}

func getIsReclaimEnabled() -> Bool {
    if let _ = defaults.object(forKey: "is_reclaim_enabled") {
        let result = defaults.bool(forKey: "is_reclaim_enabled")
        return result
    } else {
        defaults.set(false, forKey: "is_reclaim_enabled")
        return false
    }
}

func setIsReclaimEnabled(result: Bool){
    defaults.set(result, forKey: "is_reclaim_enabled")
}

func getIsGiftBanned() -> Bool {
    if let _ = defaults.object(forKey: "is_gift_banned") {
        let result = defaults.bool(forKey: "is_gift_banned")
        return result
    } else {
        defaults.set(false, forKey: "is_gift_banned")
        return false
    }
}

func setIsGiftBanned(result: Bool){
    defaults.set(result, forKey: "is_gift_banned")
}

func checkShipAlias(shipAliasUrl: String) async {
    let newVersion = shipAliasUrl.split(separator: "/").last!.replacingOccurrences(of: "formatted_ship_alias.", with: "").replacingOccurrences(of: ".json", with: "")
    let currentVersion = defaults.string(forKey: "shipAliasVersion") ?? "0.0.0"
    let result = compareVersions(currentVersion, newVersion)
    let shipAliasPath = getDocumentsDirectory().appendingPathComponent("shipAlias.json")
    
    do {
        shipAliases = try loadArrayFromJSON(ShipAlias.self, from: shipAliasPath)
//        debugPrint(shipAliases)
    } catch {
//        debugPrint("Load ShipAlias Failed")
        shipAliases = []
    }
    
    if result == .orderedAscending ||  shipAliases.count == 0 {
        let shipAlias = await CirnoApi.getShipAlias(url: URL(string: shipAliasUrl)!)
        if shipAlias.count == 0 {
            return
        }
        
        do {
            try saveArrayAsJSON(shipAlias, to: shipAliasPath)
            defaults.set(newVersion, forKey: "shipAliasVersion")
            shipAliases = shipAlias
        } catch {
//            debugPrint("Load ShipAlias Failed")
        }
    }
}

func checkTranslations(version: TranslationVersion) async -> [String: String] {
    let currentVersion = defaults.string(forKey: "translationVersion") ?? "0.0.0"
    let result = compareVersions(currentVersion, version.version)
    if result == .orderedAscending {
        var translationDict = [String: String]()
        let translations = await CirnoApi.getTranslation()
        if translations.count == 0 {
            return [:]
        }
        for translation in translations {
            translationDict[translation.english_title] = translation.title
        }
        saveDictionaryToPlist(translationDict, dictName: "translationDict")
        defaults.set(version.version, forKey: "translationVersion")
    }
    let translations = loadDictionaryFromPlist(dictName: "translationDict")
    return translations!
}

func loadUpgradeData() async {
    
    await upgradeRepo.refresh(needRefreshToken: true)
    
}

func appInit() async {
    
    try? await upgradeRepo.load()
    
    let translationVersion = await CirnoApi.getTranslationVersion()
    if translationVersion != nil {
        translationDict = await checkTranslations(version: translationVersion!)
    }
    
    var version = ""
    let systemVersion = await UIDevice.current.systemVersion
    let deviceModel = await UIDevice.current.localizedModel
    
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
       let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        version = "\(appVersion) (\(buildNumber))"
    } else {
//        debugPrint("Unable to retrieve version information.")
    }
    
    if let refugeVersion = await CirnoApi.getRefugeVersion(postBody: RefugeVersion(version: version, androidVersion: systemVersion, systemModel: deviceModel)) {
        await checkShipAlias(shipAliasUrl: refugeVersion.shipAliasUrl)
    }
    
    await RsiApi.setCsrfToken()
    
    await loadUpgradeData()
}
