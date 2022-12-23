//
//  RSIApi.swift
//  Refuge
//
//  Created by 弘培郑 on 23/12/2022.
//

import Foundation
public class RSIApi: DefaultApi{
    
    let referer = "https://robertsspaceindustries.com/"
    var rsi_device = ""
    var rsi_token = ""
    var csrf_token = ""
    var rsi_cookie_constent = "{stamp:%27yW0Q5I4vGut12oNYLMr/N0OUTu+Q5WcW8LJgDKocZw3n9aA+4Ro4pA==%27%2Cnecessary:true%2Cpreferences:true%2Cstatistics:true%2Cmarketing:true%2Cver:1%2Cutc:1647068701970%2Cregion:%27gb%27}"
    var rsi_cookie = ""
    var rsi_account_auth = ""
    var rsi_ship_upgrades_context = ""
    
    func setRSICookie(rsiToken: String, rsiDevice: String) {
        rsi_device = rsiDevice
        rsi_token = rsiToken
        rsi_cookie = "CookieConsent=$RSI_COOKIE_CONSTENT;_rsi_device=\(rsi_device);Rsi-Token=\(rsi_token)"
    }
    
    func setRSIAccountAuth(token: String) {
        rsi_account_auth = token
    }

    func setRSIShipUpgradesContext(context: String) {
        rsi_ship_upgrades_context = context
    }

    func getShipUpgradesCookie() -> String {
        return "Rsi-Ship-Upgrades-Context=\(rsi_ship_upgrades_context);Rsi-Account-Auth=\(rsi_account_auth); \(rsi_cookie)"
    }

    init() {
        super.init(serverAdress: "https://robertsspaceindustries.com")
    }
    
    func getVersion() async -> Version? {
        do {
            let value = try await getRequest(endPoint: "version/latest").serializingDecodable(Version.self).value
            return value
        } catch {
            return nil
        }
    }
}
