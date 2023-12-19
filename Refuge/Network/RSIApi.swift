//
//  RSIApi.swift
//  Refuge
//
//  Created by Summerkirakira on 23/12/2022.
//

import Foundation
import Alamofire


let RsiApi = RSIApi()


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
        // rsi_cookie = "CookieConsent=$RSI_COOKIE_CONSTENT;_rsi_device=\(rsi_device);Rsi-Token=\(rsi_token)"
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

    func getRsiBasicCookie() -> [HTTPCookie] {
        let cookie = [
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "Rsi-Token",
                .value: rsi_token,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!,
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "_rsi_device",
                .value: rsi_device,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!,
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "x-rsi-device",
                .value: rsi_device,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!,
            HTTPCookie(
                properties: [
                .domain: "robertsspaceindustries.com",
                .path: "/",
                .name: "x-rsi-token",
                .value: rsi_token,
                .secure: "TRUE",
                .expires: NSDate(timeIntervalSinceNow: 31536000)
                ]
            )!
        ]
        return cookie
    }

    func getHeaders() -> HTTPHeaders {
        let cookies = getRsiBasicCookie()
        for cookie in cookies {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        var headers: HTTPHeaders = HTTPCookieStorage.shared.cookies?.reduce(into: [:]) { dict, cookie in
                dict[cookie.name] = cookie.value
            } ?? [:]

        headers["Referer"] = referer
        headers["User-Agent"] = defaultUserAgent

        return headers
    }
    
    func getDefaultDevice() -> String {
        return "ninv6pihctq8lnzkwaqimafsdf"
    }


    func setToken(token: String) {
        rsi_token = token
    }

    func setDevice(device: String) {
        rsi_device = device
    }


    init() {
        super.init(serverAdress: "https://robertsspaceindustries.com/")
    }
    
    override func getRequest(endPoint: String) -> DataRequest {
        var request = URLRequest(url: URL(string: serverAdress + endPoint)!)
        request.method = .get
        request.headers = getHeaders()
        return AF.request(request)
    }

    func getPage(endPoint: String) async throws -> String {
//        do {
            try await withUnsafeThrowingContinuation{ continuation in
                getRequest(endPoint: endPoint).responseString { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
//        }
//        catch {
//            print(error)
//        }
    }
}
